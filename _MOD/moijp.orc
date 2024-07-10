;START CORE
PARAM_1    init 500
PARAM_2    init .5

PARAM_OUT cordelia_moogladder2_port PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE
    opcode cordelia_moogladder2_port, a, akk
    ain, kfreq, kq xin

kfreq_var   = (kfreq*11/10)-kfreq
aout        moogladder2 ain, portk(kfreq, gkbeats/12)+jitter(1, gkbeatf/8, gkbeatf)*kfreq_var, kq
aout	    balance2 aout, ain

    xout aout
    endop
;END OPCODE

