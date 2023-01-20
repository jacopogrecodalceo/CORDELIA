	instr fairest3

Sinstr		init "fairest3"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

aout	vco2 $ampvar, icps

aout	distort aout, expseg:k(random:i(.85, .15), idur, .05), gitri
aout	moogladder aout, icps + expseg:k(icps*8 + random:i(-15, 15), idur, 0.05), expseg:k(.5, idur*9/10, random:i(.895, .65), idur/10, .25)
aout	K35_hpf aout, 25, 7.5

ienvvar		init idur/10

	$death

	endin
