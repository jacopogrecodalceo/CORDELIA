;START CORE
PARAM_1     init 2.5
PARAM_2     init 7500
PARAM_3     init 1

PARAM_OUT cordelia_tape_saturation PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

	opcode cordelia_tape_saturation, a, akkk
	ain, kdrive, kcutoff, kwet xin

asat 	= tanh(kdrive * ain * kwet)
asat 	tone asat, kcutoff
aout 	= ain * (1-kwet) + asat

	xout aout
	endop

;END OPCODE

