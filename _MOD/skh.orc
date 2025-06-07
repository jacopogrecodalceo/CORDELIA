;START CORE
PARAM_1    init 500
PARAM_2    init .5
PARAM_3    init .5

PARAM_OUT cordelia_skh PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE
;START INPUT
kkk
;END INPUT
;START OPCODE
    opcode cordelia_skh, a, akkk
    ain, kfreq, kq, kwet xin

ifreq_var	init 5
askh	skf ain*kwet, a(kfreq+jitter:k(ifreq_var, gkbeatf/8, gkbeatf)), 1+(kq*3), 1
;aout	balance aout, ain

aout         =  ain*(1-kwet) + askh ; kwet is already in the delay


    xout aout
    endop
;END OPCODE