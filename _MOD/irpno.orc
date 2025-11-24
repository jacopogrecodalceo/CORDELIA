;START CORE
PARAM_1    init .5
PARAM_2    init 4096

PARAM_OUT cordelia_piano_ir PARAM_IN, PARAM_1, PARAM_2
;END CORE

;START INPUT
ki
;END INPUT

;START OPCODE

gScordelia_piano_irs[]      fillarray "/Users/j/Documents/RESEARCH/IR-SYNTHESIS/piano-body-harmonic-ch1.wav",  "/Users/j/Documents/RESEARCH/IR-SYNTHESIS/piano-body-harmonic-ch2.wav"
gicordelia_piano_irs_len    lenarray gScordelia_piano_irs

    opcode cordelia_piano_ir, a, aki
    ain, kwet, ipartitionsize xin

idel            init (ksmps < ipartitionsize ? ipartitionsize + ksmps : ipartitionsize)/sr   ; latency of pconvolve opcode

kcount  init    idel*kr

; SELECT THE FILE BASED ON CHANNELs
ich init 0
until ich > ginchnls do
    Sir = gScordelia_piano_irs[ich%gicordelia_piano_irs_len]
    prints Sir
    ich += 1
od

; since we are using a soundin [instead of in] we can do a kind of "look ahead"
; without output, creating zero-latency  by looping during one k-pass
loop:
    aconv 	pconvolve kwet*ain/48, Sir, ipartitionsize

    ain		delay  (1-kwet)*ain, idel  ; Delay dry signal, to align it with

    kcount = kcount - 1
 if kcount > 0 kgoto loop
    aout =  ain + aconv


    xout aout
    endop
;END OPCODE

