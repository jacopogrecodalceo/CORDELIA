
	instr seno

Sinstr		init "seno"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

icpsvar		init abs((icps-(icps*11/10))/6)
a1		oscil3 $ampvar, icps+random:i(-icpsvar, icpsvar), gisine
a2		oscil3 $ampvar, 3*icps+random:i(-icpsvar, icpsvar), gisine

aout 		= a1 + a2/16

ienvvar		init idur/10

	$END_INSTR

	endin
