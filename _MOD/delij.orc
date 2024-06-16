;START CORE

PARAM_1 init i(gkbeats)
PARAM_2	init .5

PARAM_OUT    cordelia_delay_array PARAM_IN, PARAM_1, PARAM_2, 4
;END CORE
;START INPUT
kk
;END INPUT

;START OPCODE

    opcode cordelia_delay_array, a, akki
    
    setksmps 1
    adel_in, kdel_time, kfb, instances xin

idel_buf    init 10

adel_dump   delayr idel_buf
adel_tap    deltap kdel_time
            delayw adel_in + (adel_tap * kfb)

adel_out    limit adel_tap, -1, 1

if instances > 1 then
    adel_out += cordelia_delay_array(adel_out, random:i(-1/12, 1/12) + kdel_time + .15*instances, kfb/instances, instances-1)/4
endif

adel_out    limit adel_out, -1, 1
    
    xout adel_out
    
    endop
;END OPCODE