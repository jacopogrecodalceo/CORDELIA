;START CORE
PARAM_1     init .35
PARAM_2     init .5
PARAM_3     init .5

PARAM_OUT cordelia_vapor_delay PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

	opcode cordelia_vapor_delay, a, akkk
	ain, kdel, kfb, kwet xin

apre		delayr .35
adel    	deltap .35
aout 		= ain + apre

	delayw ain + adel * kfb * kwet

	xout ain*(1-kwet)+aout
	endop

;END OPCODE

