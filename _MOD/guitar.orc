;START CORE
PARAM_1    init 500
PARAM_2    init .5

PARAM_OUT cordelia_guitar PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE

#define cordelia_guitar_cps(main_freq) #$main_freq+(cent(25)*jitter:k(1, gkbeatf/24, gkbeatf/8))#
#define cordelia_guitar_bw(bw) #$bw+jitter:k(1, gkbeatf/24, gkbeatf/8)#

    opcode cordelia_guitar, a, akk
    ain, kfreq, kq xin

a1    resonz ain, $cordelia_guitar_cps(ntof("2E")), $cordelia_guitar_bw(10)
a2    resonz ain, $cordelia_guitar_cps(ntof("2B")), $cordelia_guitar_bw(10)
a3    resonz ain, $cordelia_guitar_cps(ntof("2G")), $cordelia_guitar_bw(10)
a4    resonz ain, $cordelia_guitar_cps(ntof("3D")), $cordelia_guitar_bw(10)
a5    resonz ain, $cordelia_guitar_cps(ntof("3A")), $cordelia_guitar_bw(10)
a6    resonz ain, $cordelia_guitar_cps(ntof("3E")), $cordelia_guitar_bw(10)

aout    sum a1, a2, a3, a4, a5, a6
aout    balance aout, ain
    xout (ain+aout+reverb(aout, .25))/2
    endop
;END OPCODE