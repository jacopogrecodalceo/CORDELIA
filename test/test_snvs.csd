<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
0dbfs=1
nchnls=2

sr = 48000

ksmps = 32



	opcode read_buf, a, ki
	kphasor, ift xin

			setksmps 1
aout		table3 a(kphasor), ift, 1

	xout aout

	endop

gitab 		ftgen 0, 0, 0, 1,  "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/yeux.wav", 0, 0, 1

	instr 1

kphasor 	phasor .125;(sr/ftlen(gi1)*2)*.35
ift_sonvs 	init gitab

aout		read_buf kphasor, ift_sonvs

			outall aout

	endin





</CsInstruments>
<CsScore>
i 1 0 25
</CsScore>
</CsoundSynthesizer>
