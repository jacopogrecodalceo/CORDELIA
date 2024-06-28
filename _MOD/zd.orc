;START CORE
PARAM_1    init 500
PARAM_2    init .5

PARAM_OUT cordelia_zdf_ladder PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE
    opcode cordelia_zdf_ladder, a, akk
    ain, kfreq, kq xin

kfreq_var   = (kfreq*11/10)-kfreq
aout        moogladder2 ain, kfreq+jitter(1, gkbeatf/8, gkbeatf)*kfreq_var, .5+kq*15
aout	    balance2 aout, ain

    xout aout
    endop
;END OPCODE

