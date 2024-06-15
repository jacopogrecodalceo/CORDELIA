;START CORE

PARAM_1		init i(gkbeats)
PARAM_2		init .5
PARAM_3     init .5

PARAM_OUT	cordelia_flanger_mix PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

    opcode cordelia_flanger_mix, a, akkk
    ain, ktime, kfb, kmix xin

adel       flanger ain, a(ktime), kfb, 15
aout	    = ain*(1-kmix) + adel*kmix

    xout aout
    endop

;END OPCODE
