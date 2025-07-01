;START CORE
PARAM_1     init 35
PARAM_2     init .35
PARAM_3     init 1

PARAM_OUT cordelia_vapor_chorus PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

	opcode cordelia_vapor_chorus, a, akkk
	ain, kdel, kfb, kwet xin

idel_max	init 1/3
idepth 		init .0075
irate		init .25

aout	init 0
amod	oscili idepth, irate+jitter(.05, 1/8, 1/32)

;ares vdelay3 asig, adel, imaxdel [, iskip]
aout	vdelay3 ain+aout*kfb, kdel/1000 + amod, idel_max

	xout aout
	endop

;END OPCODE

