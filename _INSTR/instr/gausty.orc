	$start_instr(gausty)


irange			init (icps*11/10)-icps
alambda			gaussi irange, idyn, icps / 16

aosc			oscili $dyn_var, icps+alambda, gitri
anoi			fractalnoise $dyn_var, 1
asum			sum aosc, anoi / 3

klambda			gaussi randomi:k(5, 7, icps / 3), idyn, icps / 9
a_, aout, a_ 	zdf_2pole_mode asum / 2, alambda*4, 20+klambda; [5-25]

aout			balance2 aout, aosc
aout			butterhp aout, 20
	$dur_var(10)
	$end_instr