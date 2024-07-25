$start_instr(sallen2)

	anoi		fractalnoise 1, 1+jitter:k(1/4, 4/idur, 1/idur)
	;anoi init 0

	aosc1	oscil3 1, icps+lfo(icps/35, icps/35), gitri
	aosc2	oscil3 1, icps+lfo(icps/35, icps/35), gisaw

	aosc	= aosc1*cosseg(1, idur, 0)+aosc2*cosseg(0, idur, 1)
	aosc	*= .5 + lfo:a(.5, icps/35)

	ask		skf anoi+aosc/expseg(8, idur, 128), icps+lfo(icps/cosseg(35, idur, 100), cosseg(3, idur, random:i(1, .95))), 3

	aout	= ask*$dyn_var + aosc*$dyn_var*9

	aout	/= pow(1.45, octcps(icps))

	$dur_var(10)

$end_instr