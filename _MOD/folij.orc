;START CORE

PARAM_OUT cordelia_follow PARAM_IN, PARAM_1, ich
;END CORE
;START INPUT
Sk
;END INPUT

;START OPCODE
    opcode cordelia_follow, a, aSi
    ain, String, ich xin

adest	chnget sprintf("%s_%i", String, ich)

aenv    follow adest, i(gkbeats)/32
aout    balance2 ain, aenv/2

    xout aout
    endop
;END OPCODE