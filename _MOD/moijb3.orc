;START CORE
PARAM_1    init 500
PARAM_2    init .5

PARAM_OUT cordelia_moijb3 PARAM_IN, PARAM_1, PARAM_2
;END CORE
;START INPUT
kk
;END INPUT

;START OPCODE

gkcordelia_moijb3_port init 5$ms
gkcordelia_moijb3_freq1 init 3
gkcordelia_moijb3_freq2 init 4
gkcordelia_moijb3_freq3 init 5

    opcode cordelia_moijb3, a, akk
    ain, kfreq, kq xin

ifreq_var	init 5

kfreq1  limit kfreq + jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 20, 20$k
a1      moogladder2 ain, portk(kfreq1, gkcordelia_moijb3_port), kq

a0      init 0
kfreq2  limit gkcordelia_moijb3_freq1*kfreq + jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 20, 20$k
a2      spf a0, a0, ain, portk(kfreq2, gkcordelia_moijb3_port), 2-(kq*2)

kfreq3  limit gkcordelia_moijb3_freq2*kfreq + jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 20, 20$k
a3      spf a0, a0, ain, portk(kfreq3, gkcordelia_moijb3_port), 2-(kq*2)

kfreq4  limit gkcordelia_moijb3_freq3*kfreq + jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 20, 20$k
a4      spf a0, a0, ain, portk(kfreq4, gkcordelia_moijb3_port), 2-(kq*2)

aout    = a1 + a2 + a3 + a4

aout	balance2 aout, ain

    xout aout
    endop

;END OPCODE