<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
0dbfs=1
nchnls=2
sr = 48000
ksmps = 1

girich	hc_gen 0, 8192, 0, \ 
		hc_segment(36/56, 1, hc_power_curve(0.59521)), \ 
		hc_segment(4/56, 0.04945, hc_hamming_curve()), \ 
		hc_segment(6/56, 0, hc_kiss_curve())


girich_inv	hc_invert girich


	instr 1

ktrig metro randomi:k(.25, 3, .5)				;produce 100 triggers per second

if ktrig == 1 then
	schedulek 2, 0, 4
endif

	endin

	instr 2

idur init p3

aout = oscili:a(1/4, random:i(300, 200))*table3:a(linseg:a(1, idur, 0)*.99, girich, 1)
outall aout

	endin


</CsInstruments>
<CsScore>
i 1 0 15
e
</CsScore>
</CsoundSynthesizer>
