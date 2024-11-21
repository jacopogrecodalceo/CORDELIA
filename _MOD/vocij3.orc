; name_used:
; name_internal_opcode:
; chosen_inputs:

;START CORE

; PARAM_1 String
PARAM_2	init 1
PARAM_3	init .5


PARAM_OUT cordelia_vocoder_pvsvoc PARAM_IN, PARAM_1, PARAM_2, PARAM_3, ich

;END CORE

;START INPUT
Skk
;END INPUT


;START OPCODE
    opcode cordelia_vocoder_pvsvoc, a, aSkki
ain, Sinstr, kdyn, kwet, ich xin

acarrier   chnget sprintf("%s_%i", Sinstr, ich)

;ain, ifftsize, ioverlap, iwinsize, iwintype
ifft_size   init 4096
ioverlap    init ifft_size / 4
iwin_size   init ifft_size
iwin        init 1

fsig pvsanal ain, ifft_size, ioverlap, iwin_size, iwin   ;analyse in signal
fexc pvsanal acarrier, ifft_size, ioverlap, iwin_size, iwin   ;analyse excitation signal

; fsig, fexc, kdepth, kgain
ftps pvsvoc fsig, fexc, 1, 1            ;cross it
aout pvsynth ftps                       ;synthesise it

;aout    *= kdyn
aout	    = aout*kwet*kdyn + ain*(1-kwet)

xout aout
    endop


;END OPCODE

