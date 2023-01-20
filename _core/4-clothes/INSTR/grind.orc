gkgrind_p1	init 1
gkgrind_p2	init 1

	instr grind

Sinstr		init "grind"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ienvvar		init idur/10

igrind		i gkgrind_p1

aex		fractalnoise $ampvar, cosseg(.95, idur, .05)
aex		*= envgen((idur/8)-random:i(0, ienvvar), iftenv)

iampred		init 2.75

af		flanger aex/iampred, expseg:a((divz(idur, igrind, gizero))$s, idur, idur*10*igrind)$ms, .95
af		flanger af/iampred, expseg:a((divz(idur, igrind, gizero))$s, idur, idur*5*igrind)$ms, .95

irvt		init 1/icps
aout		comb af/iampred, irvt, irvt

krvt		cosseg idur, idur, idur/32
aout		comb aout/iampred, krvt*gkgrind_p2, irvt

aout		flanger pdhalf(aout/iampred, line(.95, idur/11, -.95)), expon:a((divz(idur, igrind, gizero))$s*.25, idur/12, idur*1.5*igrind)$ms, .75*(1-gkgrind_p2)
aout		flanger pdhalf(aout/iampred, line(-.75, idur/4, .95)), expon:a((divz(idur, igrind, gizero))$s*.15, idur/24, idur*3.5*igrind)$ms, .5*(1-gkgrind_p2)

aout		dcblock2 aout

	$death

	endin
