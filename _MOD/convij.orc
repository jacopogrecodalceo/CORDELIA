;START CORE

PARAM_2	init 1

PARAM_OUT cordelia_cross PARAM_IN, PARAM_1, ich, PARAM_2

;END CORE

;START INPUT
Sk
;END INPUT


;START OPCODE
    opcode cordelia_cross, a, aSik
    ain, String, ich, kmix xin

adest	chnget sprintf("%s_%i", String, ich)

aout    cross2 ain, adest, 4096, 2, gihanning, kmix
aout	balance2 aout, ain

    xout aout
    endop
;END OPCODE