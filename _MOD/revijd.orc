;START CORE

PARAM_1 init i(gkbeats) ;space
PARAM_2 init .5 ;high freq
PARAM_3 init .5 ;mix

PARAM_OUT cordelia_reverb_dust PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

opcode cordelia_reverb_dust, a, akkk
	ain, ktime, khigh_freq, kwet xin

		imaxdur init i(gkbeats)
		imaxdur init imaxdur*8

		while imaxdur < .5 do
			imaxdur *= 2
		od

		arev	init 0

		aenv	follow ain, 1/ksmps
		adust	dust2 1, gkbeatf*256*k(aenv)
		a_, a_, aband svfilter adust, randomh(5000, 9000, gkbeatf+gkbeatf*k(aenv)), 0

		arev	nreverb (aband/8+ain)*kwet, ktime, 1-khigh_freq

		ilen_samps = imaxdur * sr
		ibuf ftgentmp 0, 0, ilen_samps, -2, 0

		andx = phasor(1/ktime)*a(ktime*sr)
		tablew arev, andx, ibuf

		adist = a(abs(jitter:k(1, .25/ktime, 1/ktime))*ktime*sr)
		aout1 table vdelay(andx, ktime*1000, imaxdur), ibuf
		aout2 table vdelay(adist, ktime*1000, imaxdur), ibuf
		;aout *= table3:a(delay((phasor:a(1/ktime)), 1/sr*ksmps*4), gihamming, 1)
		;arev_last	nreverb aout, ktime*2, 1-khigh_freq
		aout =  ain*(1-kwet) + (aout1 + aout2)/3;*(1-kfb/4)

	xout aout
endop

;END OPCODE
