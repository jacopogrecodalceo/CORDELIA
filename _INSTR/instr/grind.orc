gkgrind_p1	init 1
gkgrind_p2	init 1

	$start_instr(grind)

	$dur_var(10)

igrind		i gkgrind_p1

aex			fractalnoise $dyn_var, cosseg(.95, idur, .05)
aex			*= envgen(idur_var, ienv)

idynred		init 2.75

af			flanger aex/idynred, expseg:a((divz(idur, igrind, gizero))$s, idur, idur*10*igrind)$ms, .95
af			flanger af/idynred, expseg:a((divz(idur, igrind, gizero))$s, idur, idur*5*igrind)$ms, .95

irvt		init 1/icps
aout		comb af/idynred, irvt, irvt

krvt		cosseg idur, idur, idur/32
aout		comb aout/idynred, krvt*gkgrind_p2, irvt

aout		flanger pdhalf(aout/idynred, line(.95, idur/11, -.95)), expon:a((divz(idur, igrind, gizero))$s*.25, idur/12, idur*1.5*igrind)$ms, .75*(1-gkgrind_p2)
aout		flanger pdhalf(aout/idynred, line(-.75, idur/4, .95)), expon:a((divz(idur, igrind, gizero))$s*.15, idur/24, idur*3.5*igrind)$ms, .5*(1-gkgrind_p2)

aout		init int(divz(idur, 2, 1))

aout		dcblock2 aout

	$end_instr

