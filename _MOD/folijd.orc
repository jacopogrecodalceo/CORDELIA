;START CORE

PARAM_2 init 1

PARAM_OUT cordelia_follow_drum PARAM_IN, PARAM_1, PARAM_2, ich
;END CORE
;START INPUT
Sk
;END INPUT

;START OPCODE
    opcode cordelia_follow_drum, a, aSki
    ;setksmps 1
    ain, String, kwet, ich xin

aduck	    chnget sprintf("%s_%i", String, ich)
aduck       moogladder2 aduck, 195, .5

if rms(aduck) > .5 && metro:k(60) ==  1 then
    ktrig = 1
else
    ktrig = 0
endif

aout         = ain*triglinseg:a(ktrig, 1, .005, 0, .095, 1)
;aout        *= 6-follow2(aduck, .005, gkbeats/4)
aout        = ain*(1-kwet) + aout*kwet
    xout aout
    endop
;END OPCODE