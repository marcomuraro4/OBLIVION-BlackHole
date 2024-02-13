(

s.waitForBoot({

SynthDef(\scifiPad, {
	arg freq = 440, att = 2, sus = 2, rel = 2,
		freqAtt = 1, freqSus = 1, freqRel = 1,
	    detune = 1e-3, ratio = 0.996,
	    vibRate = 0.1, vibDepth = 0.004,
	    t = 0.5, cutoff = 600 , amp = 0.5,
		out = 0, flag = 0;
	var env , freqEnv , sig , gate , vib , ffreq;
	gate = Line.kr(1, 0, t);
	env = EnvGen.kr(Env.linen(att, sus, rel), doneAction: 2);
	freqEnv = EnvGen.kr(Env.linen(freqAtt, freqSus, freqRel));
	freq = Line.kr(freq, freq * ratio, t);
	vib = SinOsc.kr(vibRate).range(vibDepth.neg, vibDepth) + 1;
	freq = vib * freq;
	sig = Select.ar(2.rand ,[
		Pulse.ar([freq, freq * (1 + detune), freq * (1 - detune)],
		LFNoise2.kr(t, 0.5, 0.5), 0.1).sum,
		Saw.ar([freq, freq * (1 + detune), freq * (1 - detune)]).sum
	]);
	sig = sig.tanh * env;
	if(flag == 0,{
		ffreq = max(freqEnv * freq * 12, freq * (1.1,1.2..4).choose) + 100;
		sig = MoogFF.ar(sig, ffreq, LFNoise2.kr(1 / t, 1.4, 1.5)).tanh;
		sig = RLPF.ar(sig, 1e4, 0.9).tanh;
    },{
		sig = MoogFF.ar(sig, cutoff, LFNoise2.kr(1 / t, 1.4, 1.5)).tanh;
        sig = RHPF.ar(sig, 300, 0.9).tanh;
    });
	sig = Pan2.ar(sig * amp, LFNoise2.kr(t.rand));
	Out.ar(out, sig);
}).add;

SynthDef.new(\scifiFM, {
	arg carFreq = 500, modFreq = 150, modAmp = 200,
	att = 0.01, sus = 0.5, rel = 1,
	amp = 0.3, in, out = 0;
	var car, mod, env;
	env = EnvGen.kr(Env.linen(att, sus, rel), doneAction: 2);
	mod = SinOsc.ar(modFreq, mul: modAmp);
	car = SinOsc.ar(carFreq + mod) * env * amp;
	car = Pan2.ar(car, 0, rrand(-1, 1));
	Out.ar(out, car);
}).add;

c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "Triangle.wav");

SynthDef.new(\bellsWT,{
	arg trig = 1, amp = 1, fq = 1, pos = 0, out = 0;
	var sig;
	sig = PlayBuf.ar(2, c, fq, trig, pos, doneAction: 2);
	sig = Pan2.ar(sig, 0, rrand(-1, 1));
	Out.ar(out, sig * amp);
}).add;

SynthDef.new(\particleNoise, {
	arg amp = 1, out = 0;
	var dseq, trig, sig;
	dseq = Dseq([SinOsc.ar(45).range(-5, 12), SinOsc.ar(SinOsc.ar(0.285).range(42, 48)).range(-9, 19), 9, 0, -12], inf);
	trig = Impulse.ar(SinOsc.ar(0.2).range(44, 46));
	sig = SinOsc.ar((35 + Demand.ar(trig, 0, dseq)).midicps, 0, 0.5);
	sig = RHPF.ar(sig, 200);
	sig = Pan2.ar(sig, 0, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\windWhip, {
	arg amp = 1, out = 0;
	var whooshPitch, whooseVol, swish, swishPitch = rrand(750, 1100), noise, output, timeScale = rrand(0.5, 2.5),
	trump, trumpPitch = rrand(200, 600), chain, pan, sig, stopEnv;
	whooshPitch = EnvGen.kr(
		Env(
			[0.8, 1.0, 0.9, 0.7, 0.5, 0.3, 0.24, 0.12, 0.0],
			[0.08, 0.2, 0.15, 0.11, 0.08, 0.09, 0.06, 0.18],
			2
		), timeScale: 1.3 * timeScale
	).lag(0.2);
	whooseVol = EnvGen.kr(
		Env(
			[0.0, 0.2, 0.7, 0.9, 1.0, 0.8, 0.6, 0.43, 0.22, 0.0],
			[0.4, 0.5, 0.2, 0.15, 0.17, 0.11, 0.1, 0.16, 0.28],
			2
		), timeScale: 0.9 * timeScale
	).lag(0.2, 1.5);
	stopEnv = EnvGen.kr(Env([1, 1], [5]), doneAction: 2);
	whooseVol = whooseVol * LFNoise1.kr(37.2, 0.2, 1).lag(0.2) * stopEnv;
	noise = Mix(CombC.ar(WhiteNoise.ar(rrand(0.001, 0.1)), 0.1, [whooshPitch.exprange(0.16, 0.00011), whooshPitch.exprange(0.19, 0.00013)], 0.09));
	noise = noise + BrownNoise.ar(0.1);
	swishPitch = swishPitch * LFNoise0.kr(365, 0.2, 1);
	swishPitch = swishPitch * whooshPitch.range(0.8, 1.3);
	swish = Mix.fill(3, {|i| SinOsc.ar(swishPitch + (i * whooshPitch.exprange(45, 1)), rrand(0.0, 1.0), 0.4)});
	trumpPitch = trumpPitch * whooshPitch.range(0.92, 1.08);
	trump = Mix.fill(3, {|i| SinOscFB.ar(trumpPitch * LFNoise0.kr(28, 0.06, 1).lag(0.8) * (0.8 + (i * 0.05)), 1.2, 0.8)}) * 0.6;
	trump = RHPF.ar(trump, whooshPitch.range(120, 335), 0.2);
	chain = FFT(LocalBuf(2048), trump);
	chain = PV_BinShift(chain, WhiteNoise.kr.range(0.96, 1.01), whooshPitch.range(24, 28));
	trump = IFFT(chain) * 0.2;
	pan = [Line.kr(-0.7, 0.7, 3), Line.kr(0.7, -0.7, 3)].choose;
	sig = (noise + swish + trump) * whooseVol;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	arg in, out = 0;
	var sig;
	sig = In.ar(in, 2) * 0.25;
	sig = Compander.ar(sig, sig, 0.75, 1, 0.75, 0.1, 0.4);
	sig = (sig * 0.5) + GVerb.ar(HPF.ar(sig, 60), 20, 20, mul: 0.5).tanh;
	sig = Limiter.ar(LeakDC.ar(sig));
	sig = Pan2.ar(sig, 0, 1);
	Out.ar(out, sig);
}).add;

(0.1).wait;

~reverbBus = Bus.audio(s, 2);

~reverbSynth = Synth.new(
	\reverb, [
		\in, ~reverbBus
]);

~scale = [0, 2, 5];
~fund = 19;
~ampLow = 1;
~ampMid = 0;
~ampHigh = 0;
~relAmpFM = 0.1;
~relAmpWT = 0.5;
~relAmpWW = 0.05;
~ampPN = 0;
~fxRelTime = 1;

fork{
	loop{
		var t = [10, 20, 30].choose;
		~fund = 12 + [0, 3, 7, 10, 14].choose;
		t.wait;
	};
};

fork{
	loop{
		var t = 0.6;
 		var freqLow = (~scale.choose + ~fund + (10 * (0..1).choose)).midicps;
		var freqMid = (~scale.choose + ~fund + (12 * (2..4).choose)).midicps;
		var freqHigh = (~scale.choose + ~fund + (12 * (4..6).choose)).midicps;
		~synthLow = Synth.new(
			\scifiPad, [
				\freq, freqLow,
				\att, 3.0.rand / t,
				\sus, 3.0.rand / t,
				\rel, 3.0.rand / t,
				\freqAtt, 3.0.rand / t,
				\freqSus, 3.0.rand / t,
				\freqRel, 3.0.rand / t,
				\detune, 1e-3,
				\ratio, (0.99, 0.991..1.01).choose,
				\vibRate, t / (1..10).choose,
				\vibDepth, (90..500).choose.reciprocal,
				\t, t,
				\cutoff, 300,
				\amp, ~ampLow,
				\flag, 0,
				\out, ~reverbBus
		]);
		~synthMid = Synth.new(
			\scifiPad, [
				\freq, freqMid,
				\att, 2.0.rand / t,
				\sus, 3.0.rand / t,
				\rel, 2.0.rand / t,
				\freqAtt, 2.0.rand / t,
				\freqSus, 2.0.rand / t,
				\freqRel, 2.0.rand / t,
				\detune, 1e-3,
				\ratio, (0.99, 0.991..1.01).choose,
				\vibRate, t / (1..10).choose,
				\vibDepth, (90..500).choose.reciprocal,
				\t, t,
				\cutoff, 1200,
				\amp, ~ampMid,
				\flag, 1,
				\out, ~reverbBus
		]);
		~synthHigh = Synth.new(
			\scifiPad, [
				\freq, freqHigh,
				\att, 1.0.rand / t,
				\sus, 3.0.rand / t,
				\rel, 1.0.rand / t,
				\freqAtt, 1.0.rand / t,
				\freqSus, 2.0.rand / t,
				\freqRel, 1.0.rand / t,
				\detune, 1e-3,
				\ratio, (0.99, 0.991..1.01).choose,
				\vibRate, t / (1..10).choose,
				\vibDepth, (90..500).choose.reciprocal,
				\t, t,
				\cutoff, 2200,
				\amp, ~ampHigh,
				\flag, 1,
				\out, ~reverbBus
		]);
		t.wait;
	};
};

fork{
	loop{
		var t_FX = rrand(2.0, 8.0);
		var ampFM = rrand(0.05, 0.13) * ~relAmpFM;
		t_FX.wait;
		~synthFM = Synth.new(
			\scifiFM, [
				\carFreq, rrand(500, 2000),
				\modFreq, rrand(10, 70),
				\modAmp, rrand(10, 100),
				\sus, rrand(0.01, 0.5),
				\pan, rrand(-1.0, 1.0),
				\amp, ampFM,
				\out, ~reverbBus
		]);
	};
};

fork{
	loop{
		var t_WT = ([15, 17.5, 20, 22.5, 25].choose * ~fxRelTime);
		var ampWT = Pwhite(0.2, 1, 800) * rrand(0.04, 0.13) * ~relAmpWT;
		t_WT.wait;
		x = Pbind(\instrument, \bellsWT,
			\trig, 1,
			\amp, ampWT,
			\fq, Pwhite(0.94, 1.06, 800) + rrand(0.1, 0.4),
			\pos, Prand([2000, 10000, 20000, 30000, 40000], 800),
			\dur, 0.003,
			\out, ~reverbBus
		).play;
	};
};

fork{
	loop{
		var t_WW = (rrand(10.0, 20.0) * ~fxRelTime);
		var ampWW = rrand(0.4, 0.8) * ~relAmpWW;
		t_WW.wait;
		~synthFM = Synth.new(
			\windWhip, [
				\amp, ampWW,
				\out, ~reverbBus
		]);
	};
};

~synthPN = Synth.new(
	\particleNoise, [
		\amp, ~ampPN,
		\out, ~reverbBus
]);

~minAmpLow = 0.3;
~maxAmpLow = 0.9;
~minAmpMid = 0;
~maxAmpMid = 0.35;
~minAmpHigh = 0;
~maxAmpHigh = 0.08;
~minRelAmpFM = 0.2;
~maxRelAmpFM = 0.75;
~minRelAmpWT = 0.2;
~maxRelAmpWT = 0.7;
~minRelAmpWW = 0.1;
~maxRelAmpWW = 0.7;
~minAmpPN = 0.1;
~maxAmpPN = 0.75;
~minFxRelTime = 0.5;
~maxFxRelTime = 1;
~minDist = 1;
~maxDist = 2.4;
~minDiskSize = 80;
~maxDiskSize = 500;
~minMass = 1;
~maxMass = 20;
~minRotSpeed = 0;
~maxRotSpeed = 20;
~minTemp = 1000;
~maxTemp = 10000;

NetAddr("127.0.0.1", 57120);

OSCdef('OSCreceiver',
	{ arg msg;
	  var distNorm, forceNorm, diskSizeNorm, massNorm, rotSpeedNorm, tempNorm;
	  distNorm = (msg[1] - ~minDist) / (~maxDist - ~minDist);
	  if(distNorm < 0, {
		   distNorm = 0;
	  });
	  if(distNorm > 1, {
		   distNorm = 1;
	  });
	  diskSizeNorm = (msg[2] - ~minDiskSize) / (~maxDiskSize - ~minDiskSize);
	  massNorm = (msg[3] - ~minMass) / (~maxMass - ~minMass);
	  rotSpeedNorm = (msg[4] - ~minRotSpeed) / (~maxRotSpeed - ~minRotSpeed);
	  tempNorm = (msg[5] - ~minTemp) / (~maxTemp - ~minTemp);
	  distNorm.postln;
	  diskSizeNorm.postln;
	  massNorm.postln;
	  rotSpeedNorm.postln;
	  tempNorm.postln;
	  ~ampLow = ~minAmpLow + ((~maxAmpLow - ~minAmpLow) * massNorm);
	  ~ampMid = ~maxAmpMid - ((~maxAmpMid - ~minAmpMid) * distNorm);
	  ~ampHigh = ~minAmpHigh + ((~maxAmpHigh - ~minAmpHigh) * diskSizeNorm);
	  ~relAmpFM = ~maxRelAmpFM - ((~maxRelAmpFM - ~minRelAmpFM) * distNorm);
	  ~relAmpWT = ~maxRelAmpWT - ((~maxRelAmpWT - ~minRelAmpWT) * distNorm);
	  ~relAmpWW = ~maxRelAmpWW - ((~maxRelAmpWW - ~minRelAmpWW) * distNorm);
	  ~ampPN = ~minAmpPN + ((~maxAmpPN - ~minAmpPN) * tempNorm);
	  ~synthPN.set(\amp, ~ampPN);
	  ~fxRelTime = ~maxFxRelTime - ((~maxFxRelTime - ~minFxRelTime) * distNorm);
	},
"/BlackHoleParams");

})

)