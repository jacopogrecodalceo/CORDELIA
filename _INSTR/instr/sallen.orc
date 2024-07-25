$start_instr(sallen)

	anoi		fractalnoise $dyn_var, 1+jitter:k(1/4, 4/idur, 1/idur)
	;anoi init 0
	aout		skf anoi, icps, 3
	aout	/= pow(1.45, octcps(icps))

	$dur_var(10)

$end_instr