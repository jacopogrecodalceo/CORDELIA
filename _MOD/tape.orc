;START CORE
PARAM_1    init 3.5 ; drive factor (increase for more distortion)
PARAM_2    init .65

PARAM_OUT cordelia_moogladder2 PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
kk
;END INPUT

;START OPCODE
; === TAPE SATURATION UDO ===
opcode tape_saturation, a, akk
    ain, kdrive, kwet xin

    ; nonlinear soft clipper (arctangent shaping)
    asat = tanh(kdrive * ain)

    aout = (1 - kwet) * ain + kwet * asat

    ; slight lowpass for analog feel
    aout tone aout, 8000

    xout aout
endop

;END OPCODE

