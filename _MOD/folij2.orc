;START CORE

PARAM_2 init 1

PARAM_OUT cordelia_follow2 PARAM_IN, PARAM_1, PARAM_2, ich
;END CORE
;START INPUT
Sk
;END INPUT

;START OPCODE
    opcode cordelia_follow2, a, aSki
    ;setksmps 1
    ain, String, kwet, ich xin

adest	    chnget sprintf("%s_%i", String, ich)

adest       *= .75		;reduce volume a bit
adest       tone    adest, 1500     ;smooth estimated envelope
;adest       moogladder2 adest, 500, .95
;aenv        follow2 adest, .005, .01
aenv        follow adest, .005;, .01
aout        = ain*(1-aenv)

aout        = ain*(1-kwet) + aout*kwet

    xout aout
    endop
;END OPCODE