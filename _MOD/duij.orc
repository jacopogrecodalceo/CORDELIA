;CORE

PARAM_2	init 1

PARAM_OUT    duck PARAM_IN, PARAM_1, ich, PARAM_2


;OPCODE
    opcode duck, a, aSik
    ain, Sinstr, ich, kmix xin

aenv    follow2 chnget:a(sprintf("%s_%i", Sinstr, ich)), 25$ms, 95$ms
afol	= ain * (1-aenv)

aout	= afol*kmix + ain*(1-kmix)

    xout aout
    endop

