;START CORE

PARAM_2	genarray_i 1, ginchnls
PARAM_3	init .5

PARAM_OUT cordelia_sendch PARAM_IN, ich, PARAM_1, PARAM_2

;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE
    opcode cordelia_sendch, a, aii[]k
    ain, ich, ichs[], kmix xin

ilen        lenarray ichs
indx        init 1
until indx > ginchnls do
    chnmix ain, gSmouth[indx]
od

aout	    = ain*(1-kmix)

    xout aout
    endop
;END OPCODE