;START CORE
PARAM_1    init 500
PARAM_2    init .5

PARAM_OUT cordelia_skl PARAM_IN, PARAM_1, PARAM_2
;END CORE
;START INPUT
kk
;END INPUT
;START OPCODE
    opcode cordelia_skl, a, akk
    ain, kfreq, kq xin

ifreq_var	init 5
aout	skf ain, portk(kfreq+jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 5$ms), 1+(kq*3), 0
aout	balance2 aout, ain

    xout aout
    endop
;END OPCODE
