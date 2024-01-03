;wooden kind of monophonic

;START CORE
PARAM_1    init 1
PARAM_2    init .5

PARAM_OUT cordelia_wooden2 PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE

#define cordelia_wooden2_cps(main_freq) #$main_freq+(cent(25)*jitter:k(1, gkbeatf/8, gkbeatf))#
#define cordelia_wooden2_q(main_freq) #$main_freq+jitter:k(1, gkbeatf/8, gkbeatf)#

    opcode cordelia_wooden2, a, akk
    ain, kfreq, kq xin

if1     init 1000
if2     init 3000

iq1     init 12
iq2     init 8

ilow		init 2
ihigh		init 15
itime		init i(gkbeats)
if itime <= 0 then
	itime = 1/2
endif
itime		init itime / 2
idbthresh	init 9 ; dB threshold

koct, kamp 	pitch ain, itime, ilow, ihigh, idbthresh


aexc1    mode ain, $cordelia_wooden2_cps(if1), $cordelia_wooden2_q(iq1)
aexc2    mode ain, $cordelia_wooden2_cps(if2), $cordelia_wooden2_q(iq2)

aexc    = (aexc1+aexc2)/2
;aexc    limit aexc, 0, 1

ares1   mode aexc, $cordelia_wooden2_cps(cpsoct(koct))*kfreq, $cordelia_wooden2_q(scale(kq, 500, 60))
ares2   mode aexc, $cordelia_wooden2_cps(cpsoct(koct))*kfreq, $cordelia_wooden2_q(scale(kq, 420, 53))

aout    = (ares1+ares2)/2

aout    balance2 aout, ain

    xout aout
    endop
;END OPCODE