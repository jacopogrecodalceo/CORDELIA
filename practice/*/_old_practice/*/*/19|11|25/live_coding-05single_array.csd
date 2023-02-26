<CsoundSynthesizer>

<CsOptions>

</CsOptions>


<CsInstruments>

giA[] 	init	4 

instr 1
	indx init 0

	until indx == 4 do
	inum = random(0, 1)
	giA[indx] init inum
	indx += 1
od
endin

instr 2
	indx init 0
	until indx == 4 do
	print giA[indx]
	indx += 1
od
endin

</CsInstruments>


<CsScore>
i	1	0	.05
i	2	0	.05
</CsScore>


</CsoundSynthesizer>