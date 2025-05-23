;START CORE

PARAM_1 init .5

PARAM_OUT cordelia_reverb_dust PARAM_IN, PARAM_1
;END CORE

;START INPUT
k
;END INPUT

;START OPCODE

opcode cordelia_reverb_dust, a, ak
	ain, kwet xin

		kwet limit kwet, 0, 1

		imaxdur init i(gkbeats)
		imaxdur init imaxdur*8

		while imaxdur < .5 do
			imaxdur *= 2
		od

		arev	init 0
		aenv_delay	init 0

		aenv_pre	follow ain, (ksmps/sr)*8
		aenv_delay	vdelay3 aenv_pre+aenv_delay*(.75+jitter(.25, 1/32, 1/3)), 1/$M_PI, imaxdur
					
		aenv sum aenv_pre, aenv_delay

		adust	dust2 1, gkbeatf*256*k(aenv)
		a_, a_, aband svfilter adust, randomh:k(6500, 11500, gkbeatf+gkbeatf*k(aenv_delay)), 5

		;asum	= ain * aband/2
		aconv	cross2 ain, aband, 1024, 2, gihanning, 1
		aconv	*= 4

		aout =  ain*(1-kwet) + aconv*kwet;*(1-kfb/4)

	xout aout
endop

;END OPCODE
