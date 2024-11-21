;START CORE

PARAM_OUT cordelia_dc PARAM_IN
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE
    opcode cordelia_dc, a, a
    ain xin

aout    dcblock2 ain

    xout aout
    endop
;END OPCODE

