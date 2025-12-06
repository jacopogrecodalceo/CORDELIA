;START CORE
PARAM_1    init ntof("4B")
PARAM_2    init .5

PARAM_OUT cordelia_diode_ladder PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE

    opcode cordelia_diode_ladder, a, akk
    ain, kfreq, kq xin

kfreq_var   = (kfreq*11/10)-kfreq
kfreq       = kfreq + jitter(1, gkbeatf/8, gkbeatf)*kfreq_var

; safe limit
kfreq       limit kfreq, 20, 17.5$k

; core
isaturation init 1.25
inlp        init 1
aout        diode_ladder ain, kfreq, kq*17, inlp, isaturation

kdyn_comp   pow (kfreq / giNYQUIST), -0.15
aout        *= kdyn_comp
;aout	    balance2 aout, ain

    xout aout
    endop
;END OPCODE

