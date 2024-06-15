;START CORE

PARAM_1		init i(gkbeats)
PARAM_2		init .5

PARAM_OUT	cordelia_flanger_port PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE

    opcode cordelia_flanger_port, a, akk
    ain, ktime, kfb xin

aout       flanger ain, a(portk(ktime, gkbeats/24)), portk(kfb, .025), 15

    xout aout
    endop

;END OPCODE
