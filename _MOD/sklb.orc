;START CORE
PARAM_1    init 500
PARAM_2    init .5

PARAM_OUT cordelia_sklb PARAM_IN, PARAM_1, PARAM_2
;END CORE
;START INPUT
kk
;END INPUT

;START OPCODE

gkcordelia_sklb_port init 5$ms
gkcordelia_sklb_freq init 3

    opcode cordelia_sklb, a, akk
    ain, kfreq, kq xin

ifreq_var	init 5

kfreq1  limit kfreq + jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 20, 20$k
a1      skf ain, portk(kfreq1, gkcordelia_sklb_port), 1+(kq*3), 0

a0      init 0
kfreq2  limit gkcordelia_sklb_freq*kfreq + jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 20, 20$k
a2      spf a0, a0, ain, portk(kfreq2, gkcordelia_sklb_port), 2-(kq*2)

aout    = a1 + a2

aout	balance2 aout, ain

    xout aout
    endop

;END OPCODE
