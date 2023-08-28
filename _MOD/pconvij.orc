;START CORE

PARAM_1	init 1
PARAM_2	init 1

PARAM_OUT    cordelia_pconvolve PARAM_IN, i(PARAM_1), PARAM_2, ich
;END CORE
;START INPUT
kk
;END INPUT

;START OPCODE
    opcode cordelia_pconvolve, a, aiki
    ain, ir, kmix, ich xin

SFiles[]        directory "/Users/j/Documents/PROJECTs/CORDELIA/_setting/_IR", ".wav"

inchnls         filenchnls SFiles[ir]
;inchnls         init 2

ichnl_array     init (ich%inchnls)+1

aconv           pconvolve ain, SFiles[ir], 0, ichnl_array

aout            = aconv*kmix + ain*(1-kmix)

    xout aout

    endop
;END OPCODE