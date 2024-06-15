	$start_instr(senot)


icpsvar		init (icps-(icps*11/10))/6
a1		oscil3 $dyn_var, icps+random:i(-icpsvar, icpsvar), gisine
a2		oscil3 $dyn_var, 3*icps+random:i(-icpsvar, icpsvar), gitri

aout 		= a1 + a2/16

	$dur_var(10)
	$end_instr
