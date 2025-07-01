	$start_instr(vbell)

kenv 	expseg 1, idur * .75, .0125

; FM synthesis
acar 	= oscili(1, icps)
amod 	= oscili(kenv * 750+random:i(-.5, .5), icps * 2.01 + random:i(-.5, .5))
aout 	= oscili(idyn, icps + amod)
aout	*= 1/4
; highpass and sparkle
afx 	buthp aout, 1000
afx 	= afx * .65 + aout * .45



	$dur_var(10)
	$end_instr