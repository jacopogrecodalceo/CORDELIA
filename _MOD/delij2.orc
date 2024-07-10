;START CORE

PARAM_1 init i(gkbeats)
PARAM_2	init .5
PARAM_3 init .5

PARAM_OUT    cordelia_delay PARAM_IN, PARAM_1, PARAM_2, PARAM_3
;END CORE
;START INPUT
kkk
;END INPUT

;START OPCODE

opcode cordelia_delay, a, akkk
    ain, ktime, kfb, kwet xin

    adel init 0
    adel vdelayx    kwet*(ain+adel*kfb),    a(samphold:k(ktime, changed2:k(gkbeatn))),           10,         4096
    
    aout = ain*(1-kwet) + adel

    xout aout
endop

;END OPCODE