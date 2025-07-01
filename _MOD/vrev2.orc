;START CORE
PARAM_1     init 9500
PARAM_2     init .35
PARAM_3     init .5

PARAM_OUT cordelia_vapor_reverb2 PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

	opcode cordelia_vapor_reverb2, a, akkk
	ain, kfreq_cutoff, kfblvl, kwet xin


a1, a2 reverbsc ain*kwet, K35_hpf(ain, kfreq_cutoff, .75+jitter(.15, gkbeatf/8, gkbeatf/32), 1, 2.5+jitter(1, gkbeatf/8, gkbeatf/32)), kfblvl, kfreq_cutoff

aout	= ain*(1-kwet) + a1 + a2

	xout aout
	endop

;END OPCODE

