;START CORE
;krvt	= ktime
;klpt	= kfb*(imaxlpt/1000)

PARAM_1 init i(gkbeats)
PARAM_2 init .5
PARAM_3 init .5

PARAM_OUT	vcomb_balance PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE

;START INPUT
kkk
;END INPUT
;START OPCODE
    opcode vcomb_balance, a, akkk
    ain, ktime, kfb, kmix xin

imax_t	init 15
acomb	vcomb ain, ktime, kfb*(imax_t/1000), imax_t
;acomb	balance2 acomb, ain

aout	= ain*(1-kmix) + acomb*kmix

    xout aout
    endop
;END OPCODE