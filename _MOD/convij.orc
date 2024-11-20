;START CORE

PARAM_2	init 1
PARAM_3	init 1

PARAM_OUT cordelia_cross PARAM_IN, PARAM_1, ich, PARAM_2, PARAM_3

;END CORE

;START INPUT
Skk
;END INPUT


;START OPCODE
    opcode cordelia_cross, a, aSikk
    ain, String, ich, kdyn, kmix xin

adest	    chnget sprintf("%s_%i", String, ich)

across      cross2 ain*kdyn, adest, 4096, 2, gihanning, kmix

aout	    = ain*(1-kmix) + across*kmix

    xout aout
    endop
;END OPCODE