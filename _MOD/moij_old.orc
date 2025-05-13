;START CORE
PARAM_1    init ntof("4B")
PARAM_2    init .5

PARAM_OUT cordelia_moogladder2_old PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE
    opcode cordelia_moogladder2_old, a, akk
    ain, kfreq, kq xin

kfreq_var   = (kfreq*11/10)-kfreq
kfreq       = kfreq + jitter(1, gkbeatf/8, gkbeatf)*kfreq_var
kfreq       limit kfreq, 20, 20$k
aout        moogladder2 ain, kfreq, kq
aout	    balance2 aout, ain

    xout aout
    endop
;END OPCODE

