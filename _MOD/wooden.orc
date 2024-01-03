;START CORE
PARAM_1    init 500
PARAM_2    init .5

PARAM_OUT cordelia_wooden PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE

#define cordelia_wooden_cps(main_freq) #$main_freq+(cent(25)*jitter:k(1, gkbeatf/8, gkbeatf))#
#define cordelia_wooden_q(main_freq) #$main_freq+jitter:k(1, gkbeatf/8, gkbeatf)#

    opcode cordelia_wooden, a, akk
    ain, kfreq, kq xin

if1     init 1000
if2     init 3000

iq1     init 12
iq2     init 8

aexc1    mode ain, $cordelia_wooden_cps(if1), $cordelia_wooden_q(iq1)
aexc2    mode ain, $cordelia_wooden_cps(if2), $cordelia_wooden_q(iq2)

aexc    = (aexc1+aexc2)/2
;aexc    limit aexc, 0, 1

ares1   mode aexc,  $cordelia_wooden_cps(kfreq),  $cordelia_wooden_q(scale(kq, 500, 60))
ares2   mode aexc,  $cordelia_wooden_cps(kfreq*2),  $cordelia_wooden_q(scale(kq, 420, 53))

aout    = (ares1+ares2)/2

aout    balance2 aout, ain

    xout aout
    endop
;END OPCODE