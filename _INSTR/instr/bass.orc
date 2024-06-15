	$start_instr(bass)

a1_out		oscil3 $dyn_var, icps, gisine
a2_out		foscil $dyn_var, icps, cosseg(1, idur/24, 2), cosseg(2, idur, .5), line(.25, idur, 1), gisine
a3_out		foscil $dyn_var, icps*3/2, cosseg(.25, idur/32, 2), .25, line(1, idur, 0), gisine

aout		= a1_out + a2_out/4 + a3_out/8

	$dur_var(50)
	$end_instr