	instr lucas

	$params

iarr[]		fillarray 2, 1, 3, 4, 7, 11, 18, 29, 47, 76, 123

aosc		oscili $dyn_var, limit(icps*iarr[int(linseg(0, idur/2, lenarray(iarr)-1, idur/2, 0))], 20, 20$k), gitri
aped		moogladder oscili($dyn_var*line(0, idur, 1), icps, gisquare), line(95, idur, 9.5$k), .995*$dyn_var

iran		random 0, idur/9

amoog		moogladder aosc, 4.75$k+(7*iarr[int(linseg(0, (idur/2)-iran, lenarray(iarr)-1, iran+(idur/2), 0))])-random:i(0, 1$k-1$k*$dyn_var), line(.105, idur, 1)-random:i(0, .15)

adel		flanger amoog + aped/4, cosseg:a(0, idur/2, 4*idur$ms, idur/2, 0), .995*$dyn_var

aout		= amoog + adel

aout		/= 4

$dur_var(10)

	$end_instr

	
