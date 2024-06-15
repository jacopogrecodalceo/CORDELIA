;START CORE
PARAM_1    init 500
PARAM_2    init .5

PARAM_OUT cordelia_skh PARAM_IN, PARAM_1, PARAM_2
;END CORE
;START INPUT
kk
;END INPUT
;START OPCODE
    opcode cordelia_skh, a, akk
    ain, kfreq, kq xin

ifreq_var	init 5
aout	skf ain, kfreq+jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 1+(kq*3), 1
aout	balance2 aout, ain

    xout aout
    endop
;END OPCODE