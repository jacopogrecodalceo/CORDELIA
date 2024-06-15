gkgrind3_p1	init 1

	$start_instr(grind3)

	$dur_var(10)

igrind		i gkgrind3_p1

an		fractalnoise $dyn_var, cosseg(.95, idur, .05)
ao		oscil3 $dyn_var, lfo(icps/100, 4/idur)+(icps*4), gisaw
aex		= an + ao

aex		*= envgen(idur/4, ienv)

idynred		init 64-($dyn_var*6)

af		flanger aex/idynred, expseg:a((divz(idur, igrind, gizero)), idur/(2^igrind), idur*5*igrind)$ms, .65

irvt		init 1/icps
aout		comb af, irvt, irvt

krvt		cosseg icps, idur, icps/(2^igrind)
aout		comb aout, krvt, irvt

aout		flanger pdhalf(aout/idynred, line(.95, idur/12, -.95)), expon:a((divz(idur, igrind, gizero))$s*.25, idur/24, idur*1.5*igrind)$ms, .125
aout		flanger pdhalf(aout/idynred, line(-.75, idur/4, .95)), expon:a((divz(idur, igrind, gizero))$s*.15, 35$ms, idur*3.5*igrind)$ms, .95

	$end_instr

