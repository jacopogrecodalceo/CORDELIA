;START CORE

PARAM_2	init 1

PARAM_OUT cordelia_cross8192 PARAM_IN, PARAM_1, ich, PARAM_2

;END CORE

;START INPUT
Sk
;END INPUT


;START OPCODE
    opcode cordelia_cross8192, a, aSik
    ain, String, ich, kmix xin

adest	chnget sprintf("%s_%i", String, ich)

across      cross2 ain, adest, 8192, 4, gihanning, kmix
;abalanced   balance2 across, ain

aout	    = ain*(1-kmix) + across*kmix

    xout aout
    endop
;END OPCODE