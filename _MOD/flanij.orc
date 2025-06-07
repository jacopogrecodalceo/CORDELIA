;START CORE

PARAM_1		init i(gkbeats)
PARAM_2		init .5
PARAM_3		init .5

PARAM_OUT	cordelia_flanger PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

    opcode cordelia_flanger, a, akkk
    ain, ktime, kfb, kwet xin

; imax_delay(optional) -- maximum delay in seconds (needed for inital memory allocation)
imax_delay init 5


adel        flanger ain*kwet, a(ktime), kfb, imax_delay

aout         =  ain*(1-kwet) + adel ; kwet is already in the delay

    xout aout
    endop

;END OPCODE
