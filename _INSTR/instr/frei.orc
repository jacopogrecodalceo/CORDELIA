	$start_instr(frei)

aout vco2 idyn/2+k(vco2(idyn/4, icps*11/10)), icps+k(vco2(idyn/4, icps*11/10))

icps_moog 	init (icps*11/10) - icps
kcps_moog	limit icps+cosseg:k(icps_moog*12, idur/2, icps_moog*3, idur/2, icps_moog*6), 20, 20000
aout 		moogladder2 aout, kcps_moog, .5

	$dur_var(10)
	$end_instr