	$start_instr(seno)

icpsvar		init abs((icps-(icps*11/10))/6)
a1			oscil3 $dyn_var, icps+random:i(-icpsvar, icpsvar), gisine
a2			oscil3 $dyn_var, 3*icps+random:i(-icpsvar, icpsvar), gisine

aout 		= a1 + a2/16

	$dur_var(10)
	$end_instr