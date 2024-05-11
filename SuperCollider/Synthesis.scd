// Server boot
Server.local.boot;

// MIDI devices recognition
MIDIClient.init;

// MIDI inputs connection
MIDIIn.connectAll;

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

// SOUND 2: Lead synth
(
// Sound synthesis
SynthDef(\synth, {
	|freq, vel, gate = 1, outBus, dry = 0.5|
	var sig, mod, phase;

	// Modulation and additive noise
	mod = SinOsc.kr(freq: 10, mul: 10);
	phase = SinOsc.kr(freq: 0.5, mul: 0.0, add: 1.0);

	// Output signal definition (frequency decay on Note Off)
	sig = Saw.ar(
		//fre: freq,
		freq: freq * EnvGen.kr(
			envelope: Env.asr(attackTime: 0.05, sustainLevel: 1.0, releaseTime: 0.5, curve: 1.0),
			gate: gate,
			doneAction: 0
		),
		mul: vel
	);

	// Envelope ADSR (gate = 0 closes the Synth)
	sig = sig * EnvGen.kr(
		envelope: Env.adsr(attackTime: 0.1, decayTime: 0.2, sustainLevel: 0.8, releaseTime: 0.5),
		gate: gate,
		doneAction: 2
	);

	// Stereo OUT (dry %)
	sig = Pan2.ar(in: sig, pos: 0.0);
	Out.ar(bus: 0, channelsArray: dry*sig);

	// FX parallel (wet %)
	Out.ar(bus: outBus, channelsArray: (1.0-dry)*sig);
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

// Stethoscope
s.scope(rate: \audio, numChannels: 2);
)







// EXPERIMENT: DRUM SOUNDS

(
SynthDef(\kick, {
	var sig;

	sig = SinOsc.ar(
		freq: 60 * EnvGen.kr(envelope: Env.asr(attackTime: 0.01, sustainLevel: 1.0, releaseTime: 0.2, curve: -3.0)),
		mul: EnvGen.kr(envelope: Env.adsr(attackTime: 0.01, decayTime: 0.2, sustainLevel: 1.0, releaseTime: 0.5, curve: -3.0), doneAction: 2)
	);

	//sig = sig + WhiteNoise.ar(mul: 0.2 * EnvGen.kr(envelope: Env.asr(attackTime: 0.01, sustainLevel: 1.0, releaseTime: 0.2, curve: -3.0), doneAction: 2));

	Out.ar(bus: [0,1], channelsArray: sig);
}).add;
)

(
SynthDef(\snare, {
	var sig;

	sig = LFTri.ar(
		freq: 150,
		mul: 0.5 * EnvGen.kr(
			envelope: Env.adsr(attackTime: 0.01, decayTime: 0.5, sustainLevel: 1.0, releaseTime: 0.2),
			gate: 1.0,
			doneAction: 2
		)
	);

	sig = sig + HPF.ar(
		in: WhiteNoise.ar(
			mul: EnvGen.kr(
				envelope: Env.perc(attackTime: 0.01, releaseTime: 0.2, curve: -1.0),
				gate: 1.0,
				doneAction: 2
			)
		),
		freq: 200;
	);

	Out.ar(bus: [0,1], channelsArray: sig);
}).add;
)

(
Routine({
	loop({
		Synth(\kick);
		1.yield;
	})
}).play(TempoClock(95/60));
)

// EXPERIMENT ARPEGGIATOR

(
Routine({
	loop({
		a = Synth(\synth, [\freq: 60.midicps, \vel: 1.0, \outBus: ~effectBus]);
		1.yield;
		a.set(\gate, 0);

		a = Synth(\synth, [\freq: 64.midicps, \vel: 1.0, \outBus: ~effectBus]);
		1.yield;
		a.set(\gate, 0);

		a = Synth(\synth, [\freq: 67.midicps, \vel: 1.0, \outBus: ~effectBus]);
		1.yield;
		a.set(\gate, 0);

		a = Synth(\synth, [\freq: 64.midicps, \vel: 1.0, \outBus: ~effectBus]);
		1.yield;
		a.set(\gate, 0);
	})
}).play(TempoClock(140/60));
)
