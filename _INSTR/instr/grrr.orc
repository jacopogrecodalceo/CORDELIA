	instr grrr

Sinstr		init "grrr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ienvvar		init idur/100

aex		fractalnoise $ampvar, 2

a1		= aex*cosseg(0, 25$ms, 1, 95$ms, 0)

irvt		init 1/icps
aout		comb a1, irvt, irvt

krvt		cosseg idur, idur, idur/2
aout		comb aout, krvt, irvt

aout		/= 12

	$END_INSTR

	endin
