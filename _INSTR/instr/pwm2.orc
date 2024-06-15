#define pwm2_cps #icps+jitter:k(1, gkbeatf/8, gkbeatf)#

		$start_instr(pwm2)

idyn		init idyn/4
ibound		init sr/2	; set it to sr/2 for true BL square wave
kratio		cosseg 1, idur, 0; fractional width of the pulse part of a cycle

apulse1		buzz 1, $pwm2_cps, ibound/$pwm2_cps, gisine

; comb filter to give pulse width modulation
atemp		delayr 1/idur
apulse2		deltapi limit(kratio/icps, 0, .995)
			delayw apulse1

avpw		= apulse1 - apulse2
apwmdc		integ avpw
apwm		= apwmdc + kratio - .5
aout		= apwm * idyn

aout		dcblock2 aout

		$dur_var(10)
		$end_instr
