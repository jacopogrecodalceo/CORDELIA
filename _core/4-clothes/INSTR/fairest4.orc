	instr fairest4

Sinstr		init "fairest4"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

aout	vco2 $ampvar, icps, gisine

ienvvar		init idur/10

	$death

	endin
