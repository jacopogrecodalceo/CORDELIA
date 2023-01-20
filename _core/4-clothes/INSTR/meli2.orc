	instr meli2

Sinstr		init "meli2"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7


a1		vco2 iamp, icps
a2		vco2 iamp, icps*7

aout 		= a1 + a2

aout		moogladder2 aout, icps*(cosseg:k(12, idur/8, 2)), .5
aout		flanger aout, a(125), .85


ienvvar		init idur/10

	$death

	endin
