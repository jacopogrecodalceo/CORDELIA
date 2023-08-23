	$start_instr(luv)

ivibdiv		random 4, 8

amp		= abs(lfo:a($dyn_var, cosseg(random:i(idur*.35, idur*.95)/ivibdiv, idur, random:i(idur*.75, idur*3.5)/ivibdiv)))

kcar 	= (icps/100)/4
kmod 	= .5 + .5*int(cosseg(0, idur/16, 5))
kndx	= cosseg(1, idur, icps/1000)

kcps	= icps + vibr(expseg(.05, idur, icps/(icps*12)), randomi:k(idur*3, idur*5, icps/(icps*12)), gisine)

kvib 	lfo icps/100, random:i(3, 5)

aout	foscili amp, kcps+randomi:k(-.05, .05, 1/idur, 2, 0)+kvib, kcar, kmod+randomi:k(-.0015, .0015, 1/idur, 2, 0), kndx+randomi:k(-.05, .05, 1/idur), gisine
	
	$dur_var(100)
	$end_instr


