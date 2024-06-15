;START CORE
PARAM_1    init i(gkbeatf)

PARAM_OUT absolute_dist PARAM_IN, PARAM_1
;END CORE

;START INPUT
k
;END INPUT

;START OPCODE
    opcode absolute_dist, a, ak
    ain, kp1 xin

setksmps 1

afx     balance2 abs(ain), ain
amod	abs lfo:a(1, kp1/2)

afx	*= (1-amod)
ain	*= amod

aout	= afx + ain

    xout aout
    endop
;END OPCODE