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
s.scope(rate: \audio, numChannels: 4);

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

