(
// Server boot
Server.local.boot;

// MIDI devices recognition
MIDIClient.init;

// MIDI inputs connection
MIDIIn.connectAll;
)

// MIDI debugging activation
MIDIFunc.trace(true);

// MIDI debugging deactivation
MIDIFunc.trace(false);

// Hardware INPUT configuration
s.options.numInputBusChannels_(numChannels: 0);

// Hardware OUTPUT configuration
s.options.numInputBusChannels_(numChannels: 2);

// Speakers calibration
{PinkNoise.ar(mul: 1) ! 2}.play;


// SOUND SYNTHESIS FOR MIDI KEYBOARD
(
// Sound synthesis
SynthDef(\synth, {
	|freq, vel, gate = 1, outBus, dry = 0.8|
	var sig;

	// Output signal definition (frequency decay on Note Off)
	sig = Saw.ar(
		freq: freq,
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
	Out.ar(bus: 0, channelsArray: dry * sig);

	// FX parallel (wet %)
	Out.ar(bus: outBus, channelsArray: (1.0 - dry)*sig);
}).add;

// Signal processing
SynthDef(\FX, {
	|inBus, preDelay = 0.05, lowF = 200, highF = 5000, room = 0.5, damp = 0.1|
	var sig;

	sig = In.ar(bus: inBus, numChannels: 2);		// IS SIG STEREO?

	// Delay definition
	sig = DelayN.ar(
		in: sig,
		maxdelaytime: 5.0,        // 5 seconds maximum delay allowed
		delaytime: preDelay
	);

	// High pass and low-pass filtering definition
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
	Out.ar(bus: 0, channelsArray: sig);
}).add;

// Parallel bus
~effectBus = Bus.audio(server: s, numChannels: 2);
~effectBus.index;

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
		Synth(\synth, [\freq: num.midicps, \vel: val.linexp(1, 127, 0.3, 1.0), \outBus: ~effectBus])	// Synth object
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

// SOUND SYNTHESIS FOR ARPEGGIATOR
(
// Drums sounds
SynthDef(\kick, {
	|volume = 1.0|
	var sig;

	sig = SinOsc.ar(
		freq: 50 + 50 * EnvGen.kr(
			envelope: Env.perc(attackTime: 0.0, releaseTime: 0.1, level: 1.0, curve: 'lin')
		),
		mul: EnvGen.kr(envelope: Env.linen(attackTime: 0.0, sustainTime: 0.05, releaseTime: 0.1, level: 1.0, curve: 'lin'))
	);

	sig = sig + WhiteNoise.ar(
		mul: 0.1 * EnvGen.kr(envelope: Env.perc(attackTime: 0.0, releaseTime: 0.2, level: 1.0, curve: -2.0))
	);

	Out.ar(bus: [0,1], channelsArray: (0.9*volume)*sig);
	Out.ar(bus: ~effectBus, channelsArray: (0.1*volume)*sig);
}).add;

SynthDef(\snare, {
	|volume = 0.5|
	var sig;

	sig = SinOsc.ar(
		freq: 170 * EnvGen.kr(
			envelope: Env.perc(attackTime: 0.0, releaseTime: 0.5, level: 1.0, curve: 'lin')
		),
		mul: EnvGen.kr(envelope: Env.linen(attackTime: 0.0, sustainTime: 0.05, releaseTime: 0.1, level: 1.0, curve: 'lin'))
	);

	sig = sig + WhiteNoise.ar(
		mul: EnvGen.kr(envelope: Env.perc(attackTime: 0.0, releaseTime: 0.2, level: 1.0, curve: -2.0))
	);

	Out.ar(bus: [0,1], channelsArray: (0.9*volume)*sig);
	Out.ar(bus: ~effectBus, channelsArray: (0.1*volume)*sig);
}).add;

// Bass sound
SynthDef(\bass, {
	|note, gate = 1|
	var sig;

	sig = LFTri.ar(
		freq: note.midicps * EnvGen.kr(envelope: Env(levels: [0, 1], times: 0.1, curve: 'lin'))
	);

	sig = sig + SinOsc.ar(
		freq: note.midicps/2,
		mul: 0.5
	);

	sig = sig * EnvGen.kr(
		envelope: Env.asr(attackTime: 0.01, sustainLevel: 1.0, releaseTime: 0.3, curve: -4.0),
		gate: gate,
		doneAction: 2
	);

	Out.ar(bus: [0,1], channelsArray: 0.5*sig);
	Out.ar(bus: ~effectBus, channelsArray: 0.1*sig);
}).add;

// Synth sound
SynthDef(\pick, {
	|note, volume = 0.4|
	var sig;

	sig = LFTri.ar(
		freq: note.midicps,
		mul: EnvGen.kr(envelope: Env.perc(attackTime: 0.03, releaseTime: 1.0, curve: -4.0))
	);

	sig = HPF.ar(in: sig, freq: 500);

	Out.ar(bus: [0,1], channelsArray: volume*sig);
	Out.ar(bus: [0,1], channelsArray: (0.5*volume)*sig);
}).add;
)

(
// Drum loop
~bpm = 85;
t = TempoClock(~bpm/60);

~chorusDrums = Routine({
	8.do({
		Synth(\kick);
		1.yield;

		Synth(\snare);
		0.5.yield;

		Synth(\kick);
		0.5.yield;
		Synth(\kick);
		1.yield;

		Synth(\snare);
		1.yield;
	})
});

// Bass loop
~chorusBass = Routine({
	2.do({
		a = Synth(\bass, [\note, 43]);
		4.yield;
		a.set(\gate, 0);

		a = Synth(\bass, [\note, 50]);
		1.5.yield;
		a.set(\gate, 0);

		a = Synth(\bass, [\note, 45]);
		2.5.yield;
		a.set(\gate, 0);

		a = Synth(\bass, [\note, 43]);
		4.yield;
		a.set(\gate, 0);

		a = Synth(\bass, [\note, 47]);
		1.5.yield;
		a.set(\gate, 0);

		a = Synth(\bass, [\note, 45]);
		2.5.yield;
		a.set(\gate, 0);
	})
});

~chorusHarm = Routine({
	2.do({
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;

		Synth(\pick, [\note, 66]);
		0.5.yield;
		Synth(\pick, [\note, 66]);
		0.5.yield;
		Synth(\pick, [\note, 66]);
		0.5.yield;
		Synth(\pick, [\note, 61]);
		0.5.yield;
		Synth(\pick, [\note, 61]);
		0.5.yield;
		Synth(\pick, [\note, 61]);
		0.5.yield;
		Synth(\pick, [\note, 61]);
		0.5.yield;
		Synth(\pick, [\note, 61]);
		0.5.yield;

		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;
		Synth(\pick, [\note, 59]);
		0.5.yield;

		Synth(\pick, [\note, 62]);
		0.5.yield;
		Synth(\pick, [\note, 62]);
		0.5.yield;
		Synth(\pick, [\note, 62]);
		0.5.yield;
		Synth(\pick, [\note, 61]);
		0.5.yield;
		Synth(\pick, [\note, 61]);
		0.5.yield;
		Synth(\pick, [\note, 61]);
		0.5.yield;
		Synth(\pick, [\note, 61]);
		0.5.yield;
		Synth(\pick, [\note, 61]);
		0.5.yield;
	})
});

~chorusDrums.play(t, quant: 4);
~chorusBass.play(t, quant: 4);
~chorusHarm.play(t, quant: 4);
)

// Stethoscope
s.scope(rate: \audio, numChannels: 2);

// EXPERIMENT (NOT WORKING)

(
var array1 = ['k', 's', 'k', 's', 's'];
var array2 = [1, 1, 1, 0.5, 0.5];

array1.size.do { |i|
    var drum = array1[i];
    var dur = array2[i];

    case(
		{drum == 'k'}, {do({Synth(\kick); dur.yield;})},
		{drum == 's'}, {do({Synth(\snare); dur.yield;})}
	);
};
)
