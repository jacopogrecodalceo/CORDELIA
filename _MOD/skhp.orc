;START CORE
PARAM_1    init 2
PARAM_2    init .5

PARAM_OUT cordelia_skhp PARAM_IN, PARAM_1, PARAM_2
;END CORE
;START INPUT
kk
;END INPUT
;START OPCODE
    opcode cordelia_skhp, a, akk
    ain, kfreq, kq xin

ilow		init 2
ihigh		init 15
itime		init i(gkbeats)
idbthresh	init 9 ; dB threshold

koct, kdyn 	pitch ain, itime/32, ilow, ihigh, idbthresh

ifreq_var	init 5
aout	skf ain, a(portk(cpsoct(koct), .005)*kfreq+jitter:k(ifreq_var, gkbeatf/8, gkbeatf)), 1+(kq*3), 1
;aout	balance aout, ain

    xout aout
    endop
;END OPCODE