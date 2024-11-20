; name_used:
; name_internal_opcode:
; chosen_inputs:

;START CORE

; PARAM_1 String
PARAM_2	init 128
PARAM_3	init 1
PARAM_4	init .5

PARAM_OUT cordelia_lpc_vocoder PARAM_IN, PARAM_1, PARAM_2, PARAM_3, PARAM_4, ich

;END CORE

;START INPUT
Skkk
;END INPUT


;START OPCODE
    opcode cordelia_lpc_vocoder, a, aSkkki
ain, Sinstr, kperiod, kdyn, kwet, ich xin

acarrier    chnget sprintf("%s_%i", Sinstr, ich)
isize       init 4096
iord        init 30         ; also the number of coefficients computed, typical lp orders may range from about 30 to 100 coefficients, but larger values can also be used.
iflag       init 1          ; compute flag, non-zero values switch on linear prediction analysis replacing filter coefficients, zero switch it off, keeping current filter coefficients.

aout        lpcfilter ain, acarrier, iflag, kperiod, isize, iord

aout        = aout*kwet*kdyn + ain*(1-kwet)

    xout aout
    endop

;END OPCODE

