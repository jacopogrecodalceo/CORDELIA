
<CsoundSynthesizer>
<CsOptions>
-odac -m0
</CsOptions>
<CsInstruments>

sr		= 	48000
ksmps	= 	32
nchnls	= 	2
0dbfs	=	1

	instr 1

ktime	= int(phasor(.75)*16)

if changed2(ktime) == 1 then
	ktime = ktime + 1
	printk2 ktime
else
	ktime = -1
endif


if (ktime % 16) == 0 || random:k(0, 3000) < 2 then
	schedulek "kick", 0, 1, random:k(.95, .75)
endif

if ktime % 2 == 0 || random:k(0, 5000) < 3 then
	schedulek "hh", 0, 1, random:k(.95, .85), .5
endif


	endin
	schedule 1, 0, -1

	instr kick

aout diskin "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/bd10.wav", p4
	outall aout*linseg(.5, p3, 0)

	endin

	instr snare

a1, a2 diskin "/Users/j/Downloads/platesn2.wav"
	outs a1*linseg(.5, p3, 0), a2*linseg(.5, p3, 0)

	endin

	instr hh

a1, a2 diskin "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/hh.wav", p4
	outs a1*p5, a2*p5

	endin

</CsInstruments>
<CsScore>
f0 z

</CsScore>
</CsoundSynthesizer>