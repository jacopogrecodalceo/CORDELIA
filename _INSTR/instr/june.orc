	$start_instr(june)

; 2 detuned saws
a1 			vco2 idyn * .5, icps
a2 			vco2 idyn * .5, icps * 0.997

; optional PWM layer
apwm 		vco2 idyn * .25, icps, 2, .5

; chorus
idel_max 	init .65
kdepth 		= .0075
krate  		= .25 + jitter(.05, 1/idur, 1/8) + random:i(-.05, .05)
ifb 		init .85

aout		init 0
amod		oscili kdepth, krate

;ares vdelay3 asig, adel, imaxdel [, iskip]
acorus			vdelay3 a1+a2+apwm+aout*(ifb + jitter(.05, 1/idur, 1/8)), idel_max/2 + amod, idel_max

acrunchy		K35_hpf acorus, 7500, .65, 1, 3.5
; reverb
aout1, aout2	reverbsc acorus, acrunchy, .85, 11500

; lowpass for softness
amoog			moogladder aout1 + aout2, 750+idyn*1750, .25

anoise			reson fractalnoise(idyn/4, 1), icps, (icps*11/10-icps)

aout			= amoog + anoise / 8192 * linseg(0, .005, 1, idur/8, 0)
aout			*= 2
	$dur_var(10)
	$end_instr