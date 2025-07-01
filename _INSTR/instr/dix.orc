; DX7 LOFI
	$start_instr(dix)

; FM operators
kenv 	expseg 1, idur * .95, .001
aop1 	= oscili(idyn, icps)
aop2 	= oscili(kenv * 315, icps * 2.5 + random:i(-1, 1))

aout 	= oscili(idyn, icps + aop2)

; bitcrush & alias
acrushed 	= floor(aout * 24) / 24

; noise layer for dirt
anoise 		randh .01, 1000
aout 		= (acrushed + anoise) * .75

	$dur_var(10)
	$end_instr