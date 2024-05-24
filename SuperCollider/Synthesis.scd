// MIDI devices recognition
MIDIClient.init;

// MIDI inputs connection
MIDIIn.connectAll;

// MIDI debugging activation
MIDIFunc.trace(true);

// MIDI debugging deactivation
MIDIFunc.trace(false);

// Speakers calibration
{PinkNoise.ar(mul: 1) ! 2}.play;

// Stethoscope
s.scope(rate: \audio, numChannels: 2);

// Output device specification for JUCE plugin
o.outDevice = "ASIO : Hi-Fi Cable Output";

// SOUND SYNTHESIS FOR MIDI KEYBOARD
(
// Sound synthesis
SynthDef(\synth, {
	|note, vel, gate = 1, volume = 1, outBus = 0, pan = 0, dry = 0.7, fxBus|
	var sig;

	// Output signal definition (frequency decay on Note Off "commented")
	sig = Saw.ar(
		freq: note.midicps,
		//freq: note.midicps * EnvGen.kr(
		//	envelope: Env.asr(attackTime: 0.05, sustainLevel: 1.0, releaseTime: 0.5, curve: 1.0),
		//	gate: gate,
		//	doneAction: 0
		//),
		mul: vel
	);

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
	Out.ar(bus: outBus, channelsArray: dry * sig);

	// FX parallel (wet %)
	Out.ar(bus: fxBus, channelsArray: (1.0 - dry)*sig);
}).add;

// Signal processing
SynthDef(\FX, {
	|inBus, preDelay = 0.05, lowF = 200, highF = 5000, mix = 1.0, room = 0.5, damp = 0.1, outBus = 0|
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
		mix: mix,
		room: room,
		damp: damp
	);

	// Stereo OUT
	Out.ar(bus: outBus, channelsArray: sig);
}).add;

// Parallel bus
~effectBus = Bus.audio(server: s, numChannels: 2);
//~effectBus.index;

// Signal processing path
~effectSynth = Synth(\FX, args: [\inBus: ~effectBus]);

// Dictionary definition of all Synth instances
~notes = Dictionary.new(n: 0);

// Removing all MIDIdefs
MIDIdef.freeAll;

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

	// Freeing the Synth instance by closing the envelope (gate = 0)
	synth.set(\gate, 0);
});

// Making MIDI functions immune to CTRL+. interrupt
MIDIdef(\playNote).permanent_(true);
MIDIdef(\stopNote).permanent_(true);
)

(
// OSC
var processingAdd;
processingAdd = NetAddr.localAddr;

OSCdef.freeAll;

OSCdef(\receiver, {
	|msg, time, addr, port|

	("OSC incoming message: " ++ msg).postln;
	("Coming from address " ++ addr ++ " and port " ++ port).postln;

	("Panning: " ++ msg[0]).postln;
	~notes.keysValuesDo{
		|key, value|

		value.set(\pan, msg[0]);
	};

	("Volume: " ++ msg[1]).postln;  // in [-10, 10] dB
	~notes.keysValuesDo{
		|key, value|

		value.set(\volume, msg[1].linexp(-10, 10, 0.0, 1.0));
	};

	("Mix: " ++ msg[2]).postln;
	~notes.keysValuesDo{
		|key, value|

		value.set(\mix, msg[2]);
	};

	("Room: " ++ msg[3]).postln;
	~effectSynth.set(\room, msg[3]);

	// Filter freq (chorus rate) in JUCE

	("Pitch shift: " ++ msg[5]).postln;  // in semitones
	~notes.keysValuesDo{
		|key, value|

		value.set(\note, value.get(\note)+msg[5]);
	};

	// Phaser rate in JUCE

	("Reverb decay: " ++ msg[7]).postln; // in ms (pre-delay?)
	~effectSynth.set(\preDelay, msg[7]);

}, '/Modulation_mapping', processingAdd);

)
