;START CORE
PARAM_1    init ntof("4B")
PARAM_2    init .5

PARAM_OUT cordelia_moogladder2 PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE
    opcode cordelia_moogladder2, a, akk
    ain, kfreq, kq xin

kfreq_var   = (kfreq*11/10)-kfreq
kfreq       = kfreq + jitter(1, gkbeatf/8, gkbeatf)*kfreq_var

; safe limit
kfreq       limit kfreq, 20, 20$k

; core
aout        moogladder2 ain, kfreq, kq


kdyn_comp   pow (kfreq / giNYQUIST), -0.15
aout        *= kdyn_comp
;aout	    balance2 aout, ain

    xout aout
    endop
;END OPCODE

