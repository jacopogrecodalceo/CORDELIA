;wooden kind of monophonic

;START CORE
PARAM_1    init 1
PARAM_2    init .5

PARAM_OUT cordelia_wooden3 PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE
#define cordelia_wooden3_cps(main_freq) #$main_freq+(cent(25)*jitter:k(1, gkbeatf/8, gkbeatf))#
#define cordelia_wooden3_q(main_freq) #$main_freq+jitter:k(1, gkbeatf/8, gkbeatf)#

	opcode cordelia_wooden3, a, akk
	ain, kfreq, kq xin

if1		init 1000
if2		init 3000

iq1		init 12
iq2		init 8

ilow		init 2
ihigh		init 15
itime		init ksmps/sr
if itime <= 0 then
	itime = 1/2
endif
idbthresh	init 3 ; dB threshold

koct, kamp	pitch ain, itime, ilow, ihigh, idbthresh

aexc1		mode ain, $cordelia_wooden3_cps(if1), $cordelia_wooden3_q(iq1)
aexc2		mode ain, $cordelia_wooden3_cps(if2), $cordelia_wooden3_q(iq2)

aexc		= (aexc1+aexc2)/2

kmain_freq	portk limit(cpsoct(koct), 20, 20$k), itime
kfreq1		limit kmain_freq*kfreq, 20, 20$k
kfreq2		limit kmain_freq*kfreq*2, 20, 20$k

ares1		mode aexc, $cordelia_wooden3_cps(kfreq1), $cordelia_wooden3_q(scale(kq, 50, 60))
ares2		mode aexc, $cordelia_wooden3_cps(kfreq2), $cordelia_wooden3_q(scale(kq, 42, 53))

amode		= (a(kamp)/8192)*(ares1+ares2)/4096
aout		= amode

	xout aout
	endop
;END OPCODE