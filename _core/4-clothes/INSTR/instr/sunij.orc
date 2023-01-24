	instr sunij

Sinstr		init "sunij"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

kcps		= icps+fractalnoise(icps/($M_PI*100), $M_PI_2)

kramp		expseg 64, idur/2, 48 

avco		vco2 $ampvar, kcps

aosc		oscil3 $ampvar, kcps*(1+samphold(kramp/$M_PI, metro:k(gkbeatf*cosseg($M_PI, idur, $M_PI*2)))), gitri

amoog		moogladder2 avco, icps*($M_PI*kramp*$ampvar)+fractalnoise(icps/$M_PI, $M_PI_4), $M_PI_4
amoog		balance2 amoog, avco

aout		= (avco*cosseg(0, idur, 1)*abs(lfo(.5, icps/($M_PI*100)))) + amoog + (aosc*cosseg(2, idur, 1))
aout		/= 3

ienvvar		init idur/$M_PI

	$death

	endin
