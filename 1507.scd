// =============================================
// SuperCollider Live Coding Performace
// (c) akihiro kubota, 2015
// =============================================


(
// code dump
codeDump = { arg x; x.postln; };

// boot internal server
s = Server.default;
s.options.numWireBufs = 1024*4;
s.options.memSize = 65536*4;
s.recSampleFormat = "int16";
s.recChannels = 2;
if(not(s.serverRunning), {s.boot});

// create a proxyspace
p = ProxySpace.push(s);
p.fadeTime = 1.0;
p.clock = TempoClock.default;
)

FreqScope.new(800, 600, 0, server: s);

// the end
p.end(10);
p.clear.pop;
p.free;

(
~raw.ar(2);
~out.ar(2);
~out.play;
~out.vol = 1.0;
)

~out.stop;

//
~out = { Impulse.ar(0.5, 0, 0.5, 0).dup };
~out = { SinOsc.ar(441, 0, 0.5, 0).dup };


////////////////////////////


(
~raw = {arg dur = 20, base1 = 441, base2 = 441, level = 0.8;
	var farray1, farray2, aarray1, aarray2, parray1, parray2;
	farray1 = Control.names(\farray1).kr(Array.fill(256, 0));
	farray2 = Control.names(\farray2).kr(Array.fill(256, 0));
	aarray1 = Control.names(\aarray1).kr(Array.fill(256, 0));
	aarray2 = Control.names(\aarray2).kr(Array.fill(256, 0));
	parray1 = Control.names(\parray1).kr(Array.fill(256, 0));
	parray2 = Control.names(\parray2).kr(Array.fill(256, 0));
	Mix.new(
		Pan2.ar(
			SinOsc.ar(
				Line.kr(farray1 * base1, farray2 * base2, dur),
				0.0,
				Line.kr(aarray1, aarray2, dur),
				0.0),
			Line.kr(parray1, parray2, dur), level))};
)

(
~out = {arg mix = 0.5, room = 0.5, damp = 0.5, amp = 1.0;
	var signal;
	signal = ~raw.ar;
	FreeVerb2.ar( signal[0], signal[1], mix, room, damp, amp)};
)

(
~out = { DelayN.ar(~raw.ar, 0.5) };
)


///////////

(
var tonic1 = Array.series(8, 1, 1.0) * .x Array.geom(8, 1, 5/4);
var tonic2 = Array.series(8, 1, 1.0) * .x Array.geom(8, 1, 6/5);
var tonic3 = Array.series(8, 1, 1.0) * .x [1, 5/4, 4/3, 17/8, 9/5, 2*2.sqrt, 10/3, 1.1];
var tonic4 = Array.linrand(8, 1, 4.0) * .x Array.exprand(8, 1.0, 4.0);
var tonic = tonic1 ++ tonic2 ++ tonic3 ++ tonic4;
//
var tamp1 = Array.series(8, 1, 1.0).reciprocal * .x Array.fill(8, 1);
var tamp2 = Array.series(8, 1, 1.0).reciprocal * .x Array.fill(8, 1);
var tamp3 = Array.series(8, 1, 1.0).reciprocal * .x Array.fill(8, 1);
var tamp4 = Array.series(8, 1, 1.0).reciprocal * .x Array.fill(8, 1);
var tamp = tamp1 ++ tamp2 ++ tamp3 ++ tamp4;
//
var tpan1 = Array.fill(64, {rrand(-1.0, 1.0)});
var tpan2 = Array.fill(64, {rrand(-1.0, 1.0)});
var tpan3 = Array.fill(64, {rrand(-1.0, 1.0)});
var tpan4 = Array.fill(64, {rrand(-1.0, 1.0)});
var tpan = tpan1 ++ tpan2 ++ tpan3 ++ tpan4;
//
var dominant1 = tonic1 * Array.fill(64, {[15/16, 16/15].choose});
var dominant2 = tonic2 * Array.fill(64, {[15/16, 16/15].choose});
var dominant3 = tonic3 * Array.fill(64, {[15/16, 16/15].choose});
var dominant4 = tonic4 * Array.fill(64, {[15/16, 16/15].choose});
var dominant = dominant1 ++ dominant2 ++ dominant3 ++ dominant4;
//
var damp1 = Array.series(8, 1, 1.0).reciprocal * .x Array.fill(8, 1);
var damp2 = Array.series(8, 1, 1.0).reciprocal * .x Array.fill(8, 1);
var damp3 = Array.series(8, 1, 1.0).reciprocal * .x Array.fill(8, 1);
var damp4 = Array.series(8, 1, 1.0).reciprocal * .x Array.fill(8, 1);
var damp = damp1 ++ damp2 ++ damp3 ++ damp4;
//
var dpan1 = -1.0 * tpan1;
var dpan2 = -1.0 * tpan2;
var dpan3 = -1.0 * tpan3;
var dpan4 = -1.0 * tpan4;
var dpan = dpan1 ++ dpan2 ++ dpan3 ++ dpan4;
//
//tonic.plot;
//tamp.plot;
//
~raw.setn(
	\dur, 30,
	\base1, 440,
	\base2, 110,
	\farray1, dominant.postln,
	\farray2, tonic.postln,
	\aarray1, damp.normalizeSum.postln,
	\aarray2, tamp.normalizeSum.postln,
	\parray1, dpan.postln,
	\parray2, tpan.postln
	).rebuild;
)


[1, 2, 3].normalize(50, 10000);

[[1, 2, 3], [4, 5, 6], [7, 8, 9]].scramble;
[[1, 2, 3], [4, 5, 6], [7, 8, 9]].reverse;
[[1, 2, 3], [4, 5, 6], [7, 8, 9]].rotate(1);
[[1, 2, 3], [4, 5, 6], [7, 8, 9]].flop;



////////////////////////////

(
~src.ar(1);
~filt1.ar(1);
~filt2.ar(1);
~filt3.ar(1);
~filt4.ar(1);
)

(
~out = { Resonz.ar(~filt4.ar, 7000, 0.01, 10.0).dup };
~filt4 = { Resonz.ar(~filt3.ar, 6000, 0.01, 10.0) };
~filt3 = { Resonz.ar(~filt2.ar, 5500, 0.01, 10.0) };
~filt2 = { Resonz.ar(~filt1.ar, 4000, 0.01, 10.0) };
~filt1 = { Resonz.ar(~src.ar, 3000, 0.01, 10.0) };
)

~src = { WhiteNoise.ar(10) };
~src = { BrownNoise.ar(10) };
~src = { PinkNoise.ar(100) };


(
~out = {
	var w = WhiteNoise.ar(100);
	10.do({ w = Resonz.ar(w, 22050.0.rand, 0.001, 100.0) });
	Normalizer.ar(w, 0.8, 0.01).dup; };
)

(
a = (0..100) ++ (100..50) / 100; // distribution
a = a.asRandomTable;
)


[[1, 2, 3], [4, 5, 6], [7, 8, 9]].scramble;
[[1, 2, 3], [4, 5, 6], [7, 8, 9]].reverse;
[[1, 2, 3], [4, 5, 6], [7, 8, 9]].rotate(1);
[[1, 2, 3], [4, 5, 6], [7, 8, 9]].flop;


////////////////////////

シ：15/16＝0.9375
ド：1
ド＃：16/15＝1.066
レ：9/8＝1.125
ミ♭：6/5＝1.2, √√2＝1.189
ミ：5/4＝1.25
ファ：4/3＝1.33
ファ＃：45/32=1.40, √2＝1.4142
ソ：3/2＝1.5
ソ＃：25/16＝1.5625
ラ：5/3＝1.66, √√2*√2＝1.682
シ♭：9/5=1.8
シ：15/16*2＝15/8=1.875
ド：2

ランダム音程（和音）：
Array.fill(8, {[16/15, 10/9, 9/8, 6/5, 5/4, 4/3, 2.sqrt, 3/2, 8/5, 5/3, 7/4, 16/9, 15/8].choose}).sort;
ランダムクラスター：
Array.fill(8, {[8/9, 9/10, 15/16, 1.0, 16/15, 10/9, 9/8, 16/9, 9/5, 15/8, 2.0, 32/15, 20/9, 9/4].choose}).sort;
ランダム音程列：Array.geom(8, 1, [1.2, 1.25, 1.5].choose)

広帯域音程：
Array.linrand(8, 20.0, 20000.0).sort
Array.exprand(8, 20.0, 20000.0).sort


ランダム振幅：Array.rand(64, 0.0, 1.0)
ランダム振幅：Array.fill(64, {rrand(0.0, 1.0)})
発音率：Array.fill(64, {[0, 1].wchoose([0.3, 0.7])})

Array.fill2D(8, 8, {1.0.sum3rand});


倍音列：Array.series(8, 1, 1)
奇数次倍音：Array.series(8, 1, 2)
部分倍音列：Array.series(8, 10, 1)

対称倍音列：(Array.series(4, 1, 1) ++ Array.series(4, 1, 1).reciprocal)


ノコギリ波（倍音）：Array.series(8, 1, 1).normalizeSum
矩形波（奇数次倍音）：Array.series(8, 1, 2).reciprocal.normalizeSum
三角波(奇数次倍音）：Array.series(8, 1, 2).squared.reciprocal.normalizeSum


公差の変化：Array.series(8, 1, rrand(0.01, 0.1))
初項の変化：Array.series(8, rrand(0.5, 2.0),1.0)
初項と公差を変化：Array.series(8, rrand(0.5, 2.0), rrand(0.5, 2.0))

下方倍音列：Array.series(8, 1, 1).reciprocal

等比数列による和音：Array.geom(8, 1, 5/4)

五音音程和音：Array.geom(8, 1, 2**(1/5))
全音音程和音：Array.geom(8, 1, 2**(1/6))
四分音音程和音：Array.geom(8, 1, 2**(1/24))

下降音程列（下降和音）：Array.geom(8, 1, 4/5)


5度構成の音響和音：Array.series(8, 1, 1) * .x Array.geom(8, 1, 3/2)
下方音響和音：
Array.series(8, 1, 1).reciprocal * .x Array.geom(8, 4, 3/2)
Array.series(8, 1, 1) * .x Array.geom(8, 4, 4/5)


乱数和音：
Array.linrand(8, 1000.0, 1200.0).sort
Array.exprand(8, 1000.0, 1200.0).sort

ゆらぎ：
(Array.series(8, 500.0, 400.0) + Array.rand2(8, 50.0)).sort
(Array.series(6, 400.0, 400.0) ++ Array.linrand(2, 400.0, 4800.0)).sort
(Array.series(4, 400.0, 400.0) ++ Array.linrand(4, 3200.0, 6400.0)).sort
(Array.geom(8, 1, 5/4) + Array.rand2(8, 0.1))

狭い音程と広い音程による音響和音：
Array.geom(8, 1, rrand(1.0, 1.1)) * .x Array.geom(8, 1, rrand(1.9, 2.0))

短2度×長7度：Array.geom(8, 1, 16/15) * .x Array.geom(8, 1, 15/8)
長2度×短7度：Array.geom(8, 1, 9/8) * .x Array.geom(8, 1, 16/9)

クラスター：[16/15, 9/8, 16/9, 15/8]

古典的長7和音：(Array.series(16, 1, 1) * .x [1, 4/3, 3/2, 15/8])

増3和音と減3和音：(Array.geom(8, 1, 5/4) * .x Array.geom(8, 1, 6/5))

