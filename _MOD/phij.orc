;START CORE
PARAM_1    init ntof("4B")
PARAM_2    init .5
PARAM_3    init .5

PARAM_OUT cordelia_moogladder2 PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT

;START OPCODE

    opcode cordelia_moogladder2, a, akkk
    ain, kfreq, kfb, kwet xin

iord    init 18
imode   init 1
isep    init 1/$M_PI

aout    phaser2 ain, kfreq, .5+jitter(.25, 1/32, 1/3), iord, imode, isep, kfb


    xout aout
    endop
;END OPCODE

