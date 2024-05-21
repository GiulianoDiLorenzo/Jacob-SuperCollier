(
// Server boot
Server.local.boot;

// Hardware INPUT configuration
s.options.numInputBusChannels_(numChannels: 0);

// Hardware OUTPUT configuration
s.options.numOutputBusChannels_(numChannels: 2);

// Server reboot
Server.local.reboot;
)

// Speakers calibration
{PinkNoise.ar(mul: 1) ! 2}.play;

// Stethoscope
s.scope(rate: \audio, numChannels: 2);

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
		mul: 0.8
	);

	sig = sig * EnvGen.kr(
		envelope: Env.asr(attackTime: 0.01, sustainLevel: 1.0, releaseTime: 0.3, curve: -4.0),
		gate: gate,
		doneAction: 2
	);

	Out.ar(bus: [0,1], channelsArray: 0.5*sig);
}).add;

// Lead sound
SynthDef(\pick, {
	|note, volume = 0.6|
	var sig;

	sig = LFTri.ar(
		freq: note.midicps,
		mul: EnvGen.kr(envelope: Env.perc(attackTime: 0.01, releaseTime: 0.8, curve: -4.0))
	);

	sig = sig + PinkNoise.ar(
		mul: 0.01 * EnvGen.kr(envelope: Env.perc(attackTime: 0.0, releaseTime: 0.2, level: 1.0, curve: -2.0))
	);

	sig = HPF.ar(in: sig, freq: 500);

	Out.ar(bus: [0,1], channelsArray: volume*sig);
}).add;

// Pad sound
SynthDef(\pad, {
	|note, detune = 0.8, gate = 1, volume = 0.1|
	var sig;

	sig = Saw.ar(
		freq: [note.midicps, note.midicps + SinOsc.kr(freq: detune, mul: 2)]
	);

	sig = sig * EnvGen.kr(
		envelope: Env.adsr(attackTime: 0.05, decayTime: 0.2, sustainLevel: 1.0, releaseTime: 0.5),
		gate: gate,
		doneAction: 2
	);

	sig = sig + PinkNoise.ar(
		mul: 0.5 * EnvGen.kr(
			envelope: Env.perc(attackTime: 0.01, releaseTime: 0.08, level: 1.0, curve: -4.0);
		);
	);

	Out.ar(bus: [0, 1], channelsArray: volume*sig);
}).add;
)

(
// BPM definition
~bpm = 85;
t = TempoClock(~bpm/60);

// Song
~drums = {
	// VERSE
	1.do({
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
	});

	7.do({
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
	});

	// CHANGE
	6.do({
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
	});

	// CHORUS
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
	});
}.r;

~bass = {
	// VERSE
	4.yield;

	1.do({
		a = Synth(\bass, [\note, 38]);
		7.5.yield;
		a.set(\gate, 0);

		a = Synth(\bass, [\note, 45]);
		0.5.yield;
		a.set(\gate, 0);

		a = Synth(\bass, [\note, 35]);
		6.yield;
		a.set(\gate, 0);

		a = Synth(\bass, [\note, 33]);
		2.yield;
		a.set(\gate, 0);
	});

	1.do({
		a = Synth(\bass, [\note, 38]);
		7.5.yield;
		a.set(\gate, 0);

		a = Synth(\bass, [\note, 45]);
		0.5.yield;
		a.set(\gate, 0);

		a = Synth(\bass, [\note, 35]);
		4.yield;
		a.set(\gate, 0);
	});

	// CHANGE
	2.do({
		a = Synth(\bass, [\note, 40]);
		2.yield;
		a.set(\gate, 0);

		a = Synth(\bass, [\note, 33]);
		6.yield;
		a.set(\gate, 0);
	});

	// CHORUS
	8.yield;
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
	});
}.r;

~lead = {
	// VERSE
	32.yield;

	// CHANGE
	2.do({
		Synth(\pick, [\note, 50]);
		0.5.yield;
		Synth(\pick, [\note, 50]);
		0.5.yield;
		Synth(\pick, [\note, 50]);
		0.5.yield;
		Synth(\pick, [\note, 50]);
		0.5.yield;

		Synth(\pick, [\note, 49]);
		0.5.yield;
		Synth(\pick, [\note, 49]);
		0.5.yield;
		Synth(\pick, [\note, 49]);
		0.5.yield;
		Synth(\pick, [\note, 49]);
		0.5.yield;
		Synth(\pick, [\note, 49]);
		0.5.yield;
		Synth(\pick, [\note, 49]);
		0.5.yield;
		Synth(\pick, [\note, 49]);
		0.5.yield;
		Synth(\pick, [\note, 49]);
		0.5.yield;
		Synth(\pick, [\note, 49]);
		0.5.yield;
		Synth(\pick, [\note, 49]);
		0.5.yield;
		Synth(\pick, [\note, 49]);
		0.5.yield;
		Synth(\pick, [\note, 49]);
		0.5.yield;
	});

	// CHORUS
	8.yield;
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
	});
}.r;

~pad = {
	// VERSE
	4.yield;

	1.do({
		b = Synth(\pad, [\note, 54]);
		8.yield;
		b.set(\gate, 0);

		b = Synth(\pad, [\note, 50]);
		6.yield;
		b.set(\gate, 0);

		b = Synth(\pad, [\note, 52]);
		2.yield;
		b.set(\gate, 0);
	});

	1.do({
		b = Synth(\pad, [\note, 54]);
		8.yield;
		b.set(\gate, 0);

		b = Synth(\pad, [\note, 50]);
		4.yield;
		b.set(\gate, 0);
	});

	// CHANGE
	2.do({
		b = Synth(\pad, [\note, 50]);
		2.yield;
		b.set(\gate, 0);

		b = Synth(\pad, [\note, 49]);
		6.yield;
		b.set(\gate, 0);
	});

	// CHORUS
	8.yield;
	2.do({
		b = Synth(\pad, [\note, 62]);
		4.yield;
		b.set(\gate, 0);

		b = Synth(\pad, [\note, 66]);
		1.5.yield;
		b.set(\gate, 0);

		b = Synth(\pad, [\note, 61]);
		2.5.yield;
		b.set(\gate, 0);

		b = Synth(\pad, [\note, 62]);
		8.yield;
		b.set(\gate, 0);
	})
}.r;

~drums.play(t, quant: 4);
~bass.play(t, quant: 4);
~lead.play(t, quant: 4);
~pad.play(t, quant: 4);
)
