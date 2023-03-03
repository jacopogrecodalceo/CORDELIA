;CORE
PARAM_1    init i(gkbeatf)

PARAM_OUT abj PARAM_IN, PARAM_1

;OPCODE
    opcode abj, a, ak
    ain, kp1 xin

afx     balance2 abs(ain), ain
amod	abs lfo:a(1, kp1/2)

afx	*= (1-amod)
ain	*= amod

aout	= afx + ain

    xout aout
    endop
