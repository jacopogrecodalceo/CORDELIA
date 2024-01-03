<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
0dbfs=1
nchnls=2

sr = 48000

ksmps = 32

	instr 1
ipiano   sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/flute.sf2"
sfpassign 0, ipiano
sfilist ipiano
	endin
	schedule 1, 0, 0

	instr 2

aout	sfplay3m 1, ftom:i(A4), .125/4096, ntof("3A"), 1, 1
	outall aout
	endin
	schedule 2, 0, 1


</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
