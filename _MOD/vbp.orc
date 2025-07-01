;START CORE
PARAM_1     init 200
PARAM_2     init 6500
PARAM_3     init .5

PARAM_OUT cordelia_vapor_bandpass PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

	opcode cordelia_vapor_bandpass, a, akkk
	ain, klow, khigh, kwet xin

alow  	tone ain*kwet, klow
ahigh 	buthp ain*kwet, khigh

aout	= ain * (1-kwet) + (alow - ahigh)

    xout aout 
	endop

;END OPCODE

