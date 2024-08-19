	$start_instr(bass2)

kjit    	jitter 1, .15, .25
aout    	oscil3 $dyn_var, cosseg(icps*11/10, idur/8, icps)+kjit, gisine

	$dur_var(50)
	$end_instr