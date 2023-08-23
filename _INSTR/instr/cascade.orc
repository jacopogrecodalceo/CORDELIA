	$start_instr(cascade)

idur	init idur*3

ipan	init icps/100

asquare 		poscil	1, expseg(icps, idur, icps+random:i(-ipan, ipan)), gisquare
asaw			poscil	$dyn_var, icps*asquare, gisaw

adel			linseg idur/48, idur, idur*random:i(3.95, 4)

kfb			expseg random:i(.015, .075), idur, random:i(.5, .75)

aout			flanger asaw, adel, kfb
aout			/= 16

	$dur_var(5)
	$end_instr
