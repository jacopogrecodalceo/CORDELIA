	instr org

	$params

ival[]	fillarray 6, 6, 3, 4

kc1	= 5
kc2	= 5
kvrate	= gkbeatf*ival[linseg(0, idur, lenarray(ival))]
kvdpth	cosseg 0, idur, .15

aout	fmb3 $ampvar, icps, kc1, kc2, kvdpth, kvrate

ienvvar	init idur/10

	$death

	endin
