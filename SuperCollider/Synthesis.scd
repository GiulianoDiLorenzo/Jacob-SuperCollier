// MIDI devices recognition
MIDIClient.init;

// MIDI inputs connection
MIDIIn.connectAll;

// MIDI debugging activation
MIDIFunc.trace(true);

// MIDI debugging deactivation
MIDIFunc.trace(false);


// SOUND SYNTHESIS FOR MIDI KEYBOARD
(
// Sound synthesis
SynthDef(\synth, {
	|note, vel, gate = 1, volume = 1, outBus = 0, pan = 0, mix = 0.7, fxBus|
	var sig;

	// Output signal definition (frequency decay on Note Off "commented")
	sig = Saw.ar(
		freq: note.midicps,
		mul: vel
	);

	// Alternative output definition - frequency decay on NoteOff
	//sig = Saw.ar(
	//	freq: note.midicps * EnvGen.kr(
	//		envelope: Env.asr(attackTime: 0.05, sustainLevel: 1.0, releaseTime: 0.5, curve: 1.0),
	//		gate: gate,
	//		doneAction: 0
	//	),
	//	mul: vel
	//);

	// Envelope ADSR (gate = 0 closes the Synth)
	sig = sig * EnvGen.kr(
		envelope: Env.adsr(attackTime: 0.05, decayTime: 0.2, sustainLevel: 1.0, releaseTime: 0.5),
		gate: gate,
		doneAction: 2
	);

	// Pink noise (percussive attack)
	sig = sig + PinkNoise.ar(
		mul: 0.5 * EnvGen.kr(
			envelope: Env.perc(attackTime: 0.01, releaseTime: 0.08, level: 1.0, curve: -4.0);
		);
	);

	// Volume sensor
	sig = sig * volume;

	// Stereo OUT (dry %)
	sig = Pan2.ar(in: sig, pos: pan);
	Out.ar(bus: outBus, channelsArray: mix * sig);

	// FX parallel (wet %)
	Out.ar(bus: fxBus, channelsArray: (1.0 - mix)*sig);
}).add;

// Signal processing
SynthDef(\FX, {
	|inBus, preDelay = 0.05, lowF = 200, highF = 5000, room = 0.5, damp = 0.1, outBus = 0|
	var sig;

	sig = In.ar(bus: inBus, numChannels: 2);		// IS SIG STEREO?

	// Delay definition
	sig = DelayN.ar(
		in: sig,
		maxdelaytime: 5.0,        // 5 seconds maximum delay allowed
		delaytime: preDelay
	);

	// Bandpass definition
	sig = HPF.ar(
		in: sig,
		freq: lowF
	);
	sig = LPF.ar(
		in: sig,
		freq: highF
	);

	// Reverb definition
	sig = FreeVerb2.ar(
		in: sig[0],		// LEFT
		in2: sig[1],	// RIGHT
		mix: 1.0,
		room: room,
		damp: damp
	);

	// Stereo OUT
	Out.ar(bus: outBus, channelsArray: sig);
}).add;
)


// SIGNAL PATH AND MIDI
(
// Parallel bus
~effectBus = Bus.audio(server: s, numChannels: 2);

// Signal processing path
~effectSynth = Synth(\FX, args: [\inBus: ~effectBus]);

// Dictionary definition for all playing Synth instances
~notes = Dictionary.new(n: 0);

// Last value of pitch shift (for OSC-based interaction)
~lastPitchShift = 0;

// MIDI Note On
MIDIdef.noteOn(\playNote, {
	|val, num, chan, src|

	// Adding Synth instance inside ~notes
	~notes.put(
		"Synth"++num,		// Synth instance name
		Synth(\synth, [\note: num, \vel: val.linexp(1, 127, 0.3, 1.0), \fxBus: ~effectBus])	// Synth object
	);
});

// MIDI Note Off
MIDIdef.noteOff(\stopNote, {
	|val, num, chan, src|
	var synth;

	// Searching for the specific Synth instance inside ~notes
	synth = ~notes.at("Synth"++num);

	// Deleting the Synth instance from ~notes
	~notes.removeAt("Synth"++num);

	// Freeing the Synth instance by closing the ADSR envelope (gate = 0)
	synth.set(\gate, 0);
});

// Making MIDI functions immune to CTRL+. interrupt
MIDIdef(\playNote).permanent_(true);
MIDIdef(\stopNote).permanent_(true);
)


// OSC communication
(
// Response function definition
OSCdef(\receiver, {
	|msg, time, addr, port|

	//("OSC incoming message: " ++ msg).postln;
	//("Coming from address " ++ addr ++ " and port " ++ port).postln;

	// Panning at msg[1]
	if (msg[1].isNaN == false){
		// Setting pan for each Synth instance
		~notes.keysValuesDo{
			|key, value|

			value.set(\pan, msg[1]);
		};
	};

	// Mix at msg[2]
	if (msg[2].isNaN == false){
		// Setting mix for each Synth instance
		~notes.keysValuesDo{
			|key, value|

			value.set(\mix, msg[2]);
		};
	};

	// Room at msg[3]
	if (msg[3].isNaN == false){
		// Setting room for ~effectSynth
		~effectSynth.set(\room, msg[3]);
	};

	// Volume at msg[4]
	if (msg[4].isNaN == false){
		// Setting volume for each Synth instance
		~notes.keysValuesDo{
			|key, value|

			// Linear mapping from [0, 20] to [0.0, 1.0]
			value.set(\volume, (msg[4] + 20).linlin(0.5, 19.6, 0.0, 1.0));
		};
	};

	// Pitch shift at msg[6]
	if (msg[6].isNaN == false && msg[6] != ~lastPitchShift){
		// Updating ~lastPitchShift
		~lastPitchShift = msg[6];

		// Setting shifted note for each Synth instance
		~notes.keysValuesDo{
			|key, value|
			var shift;

			value.get(\note, {
				|item|
				
				value.set(\note, item + msg[6]);
			});
		};
	};

	// Reverb pre-delay at msg[8]
	if (msg[8].isNaN == false) {
		// Setting preDelay for ~effectSynth
		~effectSynth.set(\preDelay, msg[8]);
	};

}, '/Effects_Values'/*, NetAddr("127.0.0.1", 53398)*/);

)

// Output device specification for JUCE plugin
o = Server.default.options;
o.outDevice = "ASIO : Hi-Fi Cable Input";
