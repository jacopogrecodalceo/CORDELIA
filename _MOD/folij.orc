;START CORE

PARAM_2 init 1

PARAM_OUT cordelia_follow PARAM_IN, PARAM_1, PARAM_2, ich
;END CORE
;START INPUT
Sk
;END INPUT

;START OPCODE
    opcode cordelia_follow, a, aSki
    ;setksmps 1
    ain, String, kwet, ich xin

aduck	    chnget sprintf("%s_%i", String, ich)

/* adest       *= .75		;reduce volume a bit
adest       tone    adest, 500     ;smooth estimated envelope
;adest       moogladder2 adest, 500, .95
;aenv        follow2 adest, .005, .01
aenv        follow adest, .005;, .01
aout        balance ain, aenv */

kthresh     init 0
klo_knee    init 48
khi_knee    init 60
kratio      init 5.5
katk        init .005
krel        init .05
ilookahead  init 50/1000

aout        compress ain, aduck, kthresh, klo_knee, khi_knee, kratio, katk, krel, ilookahead
aout        = ain*(1-kwet) + aout*kwet

    xout aout
    endop
;END OPCODE