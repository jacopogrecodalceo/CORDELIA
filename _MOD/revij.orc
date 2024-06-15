;START CORE

PARAM_1 init i(gkbeats) ;space
PARAM_2 init .5 ;high freq
PARAM_3 init .5 ;mix

PARAM_OUT reverb_1 PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE


	opcode reverb_1, a, akkk
	ain, ktime, khigh_freq, kmix xin

arev	nreverb ain, ktime, 1-khigh_freq
aout	= ain*(1-kmix) + arev*kmix

	xout aout
	endop
;END OPCODE
