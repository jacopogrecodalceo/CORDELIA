	$start_instr(sunij)

kcps		= icps+fractalnoise(icps/($M_PI*100), $M_PI_2)

kramp		expseg 64, idur/2, 48 

avco		vco2 $dyn_var, kcps

aosc		oscil3 $dyn_var, kcps*(1+samphold(kramp/$M_PI, metro:k(gkbeatf*cosseg($M_PI, idur, $M_PI*2)))), gitri

amoog		moogladder2 avco, icps*($M_PI*kramp*$dyn_var)+fractalnoise(icps/$M_PI, $M_PI_4), $M_PI_4
amoog		balance2 amoog, avco

aout		= (avco*cosseg(0, idur, 1)*abs(lfo(.5, icps/($M_PI*100)))) + amoog + (aosc*cosseg(2, idur, 1))
aout		/= 3

idur_var	init idur/$M_PI

	$end_instr

