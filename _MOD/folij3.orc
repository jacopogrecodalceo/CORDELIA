;START CORE

PARAM_2 init 1

PARAM_OUT cordelia_follow3 PARAM_IN, PARAM_1, PARAM_2, ich
;END CORE
;START INPUT
Sk
;END INPUT

;START OPCODE
    opcode cordelia_follow3, a, aSki
    ;setksmps 1
    ain, String, kwet, ich xin

aduck	    chnget sprintf("%s_%i", String, ich)

aout        = ain*(1-follow2(aduck, .005, gkbeats/4))
aout        = ain*(1-kwet) + aout*kwet
    xout aout
    endop
;END OPCODE