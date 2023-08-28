;START CORE

PARAM_2	init 1

PARAM_OUT    cordelia_duck PARAM_IN, PARAM_1, ich, PARAM_2
;END CORE
;START INPUT
Sk
;END INPUT

;START OPCODE

gkcordelia_duck_atk init 5$ms
gkcordelia_duck_rel init 75$ms

    opcode cordelia_duck, a, aSik
    ain, Sinstr, ich, kmix xin

aenv    follow2 chnget:a(sprintf("%s_%i", Sinstr, ich)), gkcordelia_duck_atk, gkcordelia_duck_rel
afol	= ain * (1-aenv)

aout	= afol*kmix + ain*(1-kmix)

    xout aout
    endop

;END OPCODE