;CORE
PARAM_1    init 500
PARAM_2    init .5

PARAM_OUT mooj PARAM_IN, PARAM_1, PARAM_2

;OPCODE
    opcode mooj, a, akk
    ain, kfreq, kq xin

ifreq_var	init 5
aout	moogladder2 ain, kfreq+randomi:k(-ifreq_var, ifreq_var, .05), kq
aout	balance2 aout, ain

    xout aout
    endop
