gkgrind3_p1	init 1

	instr grind3

Sinstr		init "grind3"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ienvvar		init idur/10

igrind		i gkgrind_p1

an		fractalnoise $ampvar, cosseg(.95, idur, .05)
ao		oscil3 $ampvar, lfo(icps/100, 4/idur)+(icps*4), gisaw
aex		= an + ao

aex		*= envgen((idur/4)-random:i(0, ienvvar), iftenv)

iampred		init 8-($ampvar*6)

af		flanger aex/iampred, expseg:a((divz(idur, igrind, gizero)), idur/(2^igrind), idur*5*igrind)$ms, .65

irvt		init 1/icps
aout		comb af, irvt, irvt

krvt		cosseg icps, idur, icps/(2^igrind)
aout		comb aout, krvt, irvt

aout		flanger pdhalf(aout/iampred, line(.95, idur/12, -.95)), expon:a((divz(idur, igrind, gizero))$s*.25, idur/24, idur*1.5*igrind)$ms, .125
aout		flanger pdhalf(aout/iampred, line(-.75, idur/4, .95)), expon:a((divz(idur, igrind, gizero))$s*.15, 35$ms, idur*3.5*igrind)$ms, .95

	$death

	endin
