(
// Server boot
Server.local.boot;

// MIDI devices recognition
MIDIClient.init;

// MIDI inputs connection
MIDIIn.connectAll;

// Hardware INPUT configuration
s.options.numInputBusChannels_(numChannels: 0);

// Hardware OUTPUT configuration
s.options.numOutputBusChannels_(numChannels: 2);

// Server reboot
Server.local.reboot;
)

// MIDI debugging activation
MIDIFunc.trace(true);

// MIDI debugging deactivation
MIDIFunc.trace(false);

// Speakers calibration
{PinkNoise.ar(mul: 1) ! 2}.play;

// Stethoscope
s.scope(rate: \audio, numChannels: 4);


// SOUND SYNTHESIS FOR MIDI KEYBOARD
(
// Sound synthesis
SynthDef(\synth, {
	|freq, vel, detune = 0.8, gate = 1, outBus = 0, fxBus, dry = 0.7|
	var sig;

	// Output signal definition (FM and frequency decay on Note Off "commented")
	sig = Saw.ar(
		freq: freq + SinOsc.kr(freq: detune, mul: 5),
		//freq: freq * EnvGen.kr(
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

	// Stereo OUT (dry %)
	sig = Pan2.ar(in: sig, pos: 0.0);
	Out.ar(bus: outBus, channelsArray: dry * sig);

	// FX parallel (wet %)
	Out.ar(bus: fxBus, channelsArray: (1.0 - dry)*sig);
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

// Output bus (for VST plugin)
~vstBus = Bus.audio(server: s, numChannels: 2);
//~vstBus.index;

// Parallel bus
~effectBus = Bus.audio(server: s, numChannels: 2);
//~effectBus.index;

// Signal processing path
~effectSynth = Synth(\FX, args: [\inBus: ~effectBus, \outBus, ~vstBus]);

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
		Synth(\synth, [\freq: num.midicps, \vel: val.linexp(1, 127, 0.3, 1.0), \outBus, ~vstBus, \fxBus: ~effectBus])	// Synth object
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
