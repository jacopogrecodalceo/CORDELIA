	$start_instr(fairest3f)

aout	vco2 $dyn_var, icps

aout	distort aout, cosseg:k(.65, idur, .05), gitri
aout	moogladder aout, icps + expseg:k(icps*8, idur, 0.05), expseg:k(.5, idur*9/10, .765, idur/10, .25)
aout	K35_hpf aout, 25, 7.5

	$dur_var(10)
	$end_instr
