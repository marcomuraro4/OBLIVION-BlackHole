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
	pan = 0, amp = 0.3, in, out = 0;
	var car, mod, env;
	env = EnvGen.kr(Env.linen(att, sus, rel), doneAction: 2);
	mod = SinOsc.ar(modFreq, mul: modAmp);
	car = SinOsc.ar(carFreq + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(out, car);
}).add;

c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "Triangle.wav");

SynthDef.new(\bellsWT,{
	arg trig = 1, amp = 1, fq = 1, pos = 0, out = 0;
	var sig;
	sig = PlayBuf.ar(2, c, fq, trig, pos, doneAction: 2);
	Out.ar(out, sig * amp);
}).add;

SynthDef.new(\lowpass, {
	arg cut = 24000, in, out = 0;
	var sig;
	sig = In.ar(in, 2);
	sig = RLPF.ar(sig, cut);
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	arg in, out = 0;
	var sig;
	sig = In.ar(0, 2) * 0.25;
	sig = Compander.ar(sig, sig, 0.75, 1, 0.75, 0.1, 0.4);
	sig = (sig * 0.5) + GVerb.ar(HPF.ar(sig, 60), 20, 20, mul: 0.5).tanh;
	sig = Limiter.ar(LeakDC.ar(sig));
	Out.ar(out, sig);
}).add;

(0.1).wait;

~lowpassBus = Bus.audio(s, 2);
~reverbBus = Bus.audio(s, 2);

~lowpassSynth = Synth.new(
		\lowpass, [
			\in, ~lowpassBus,
			\out, ~reverbBus,
]).register;

~reverbSynth = Synth.new(
		\reverb, [
			\in, ~reverbBus,
]).register;

~scale = [0, 2, 5];
~fund = 19;

~ampLow = 1;
~ampMid = 0;
~ampHigh = 0;
~relAmpFM = 0.1;
~relAmpWT = 0.5;

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
				\out, ~lowpassBus
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
				\out, ~lowpassBus
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
				\flag, 1
				\out, ~lowpassBus
		]);
		t.wait;
	};
};

fork{
	loop{
		var t_FX = rrand(1.0, 8.0);
		var ampFM = rrand(0.05, 0.13) * ~relAmpFM;
		~synthFM = Synth.new(
			\scifiFM, [
				\carFreq, rrand(500, 2000),
				\modFreq, rrand(10, 70),
				\modAmp, rrand(10, 100),
				\sus, rrand(0.01, 0.5),
				\pan, rrand(-1.0, 1.0),
				\amp, ampFM,
				\out, ~lowpassBus
		]);
		t_FX.wait;
	};
};

fork{
	loop{
		var t_WT = [10, 15, 20].choose;
		var ampWT = Pwhite(0.2, 1, 800) * rrand(0.04, 0.13) * ~relAmpWT;
		t_WT.wait;
		x = Pbind(\instrument, \bellsWT,
			\trig, 1,
			\amp, ampWT,
			\fq, Pwhite(0.94, 1.06, 800) + rrand(0.1, 0.4),
			\pos, Prand([2000, 10000, 20000, 30000, 40000], 800),
			\dur, 0.003,
			\out, ~lowpassBus
		).play;
	};
};

/*
{
	var sig = In.ar(0, 2);
	sig = sig * 0.25;
	sig = Compander.ar(sig, sig, 0.75, 1, 0.75, 0.1, 0.4);
	sig = (sig * 0.5) + GVerb.ar(HPF.ar(sig, 60), 20, 20, mul: 0.5).tanh;
	sig = Limiter.ar(LeakDC.ar(sig));
	ReplaceOut.ar(0, sig)
}.play(addAction: \addToTail);
*/

~minAmpLow = 1;
~maxAmpLow = 1.25;
~minAmpMid = 0;
~maxAmpMid = 0.8;
~minAmpHigh = 0;
~maxAmpHigh = 0.07;
~minRelAmpFM = 0.1;
~maxRelAmpFM = 1;
~minRelAmpWT = 0.5;
~maxRelAmpWT = 1;
~alpha = 0.5 * (sqrt(2) - 1 + sqrt(2 * sqrt(2) - 1));
~beta = - 1 / ((1 + ~alpha).squared);

NetAddr("127.0.0.1", 57120);

OSCdef('OSCreceiver',
	{ arg msg;
	  var distNorm, forceNorm;
	  distNorm = msg[1];
	  if(distNorm < 0, {
		   distNorm = 0;
	  });
	  if(distNorm > 1, {
		   distNorm = 1;
	  });
	  forceNorm = ~beta + (1 / ((distNorm + ~alpha).squared));
	  ~ampLow = ~minAmpLow + ((~maxAmpLow - ~minAmpLow) * forceNorm);
	  ~ampMid = ~maxAmpMid - ((~maxAmpMid - ~minAmpMid) * distNorm);
	  ~ampHigh = ~maxAmpHigh - ((~maxAmpHigh - ~minAmpHigh) * distNorm);
	  ~relAmpFM = ~maxRelAmpFM - ((~maxRelAmpFM - ~minRelAmpFM) * distNorm);
	  ~relAmpWT = ~maxRelAmpWT - ((~maxRelAmpWT - ~minRelAmpWT) * distNorm);
	  var inNebula;
	  inNebula = msg[2];
	  if(inNebula == 0, {
			if(~lowpassSynth.isPlaying) {
				~lowpassSynth.set(\cut, XLine.kr(24000, 700, 2));
			}
	  }, {
			if(~lowpassSynth.isPlaying) {
				~lowpassSynth.set(\cut, XLine.kr(700, 24000, 2));
			}
	  });
	},
"/OSCTest");

})

)