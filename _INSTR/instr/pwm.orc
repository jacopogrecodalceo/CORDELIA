		$start_instr(pwm)

idyn		init idyn/4
ibound		init sr/4	; set it to sr/2 for true BL square wave
kratio		line .01, idur, .99; fractional width of the pulse part of a cycle
apulse1		buzz 1, icps, ibound/icps, gisine

; comb filter to give pulse width modulation
atemp		delayr 1/20
apulse2		deltapi limit(kratio/icps, 0, .995)
			delayw apulse1

avpw		= apulse1 - apulse2
apwmdc		integ avpw
apwm		= apwmdc + kratio - .5
aout		= apwm * idyn
aout		dcblock2 aout
		$dur_var(10)
		$end_instr
