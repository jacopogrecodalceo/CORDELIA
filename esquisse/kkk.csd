<CsoundSynthesizer>
<CsOptions>
-d -odac -W -3 
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 1
nchnls = 2
0dbfs = 1


gileda	hc_gen 0, 16384, 0, \ 
		hc_segment(1/11, 1, hc_cubic_curve()), \ 
		hc_segment(10/11, 0, hc_diocles_curve(1))


	instr 1

if metro:k(2)==1 then
	schedulek 2, 0, .5
endif

	endin


	instr 2

idur = p3
icps = 50


ashape	tablei linseg(0, p3, 1), gileda, 1
;ashape	linseg 0, .005, 1, p3-.005, 0

afreq	= ashape+(ashape*icps)+icps/10

aout	oscil3 1, afreq
aout	= tanh(aout)

aout    *= ashape

	outall aout

	endin



</CsInstruments>
<CsScore>
i 1 0 15
</CsScore>
</CsoundSynthesizer>