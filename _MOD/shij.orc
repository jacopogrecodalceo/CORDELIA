;START CORE
PARAM_1    init .5
PARAM_2    init .45
PARAM_3    init 2
PARAM_4    init .5

PARAM_OUT cordelia_shimmer_reverb PARAM_IN, PARAM_1, PARAM_2, PARAM_3, PARAM_4
;END CORE
;START INPUT
kkkk
;END INPUT
;START OPCODE
    opcode cordelia_shimmer_reverb, a, akkkk
    ain, ktime, kfb, kratio, kwet xin

; Author: Steven Yi
imaxdel     init 15000

; pre-delay
adel        vdelay3 ain*kwet, a(ktime*1000), imaxdel

afb         init 0

adel        = adel + (afb * a(kfb))

; important, or signal bias grows rapidly
adel        dcblock2 adel
adel        tanh adel

a_          = 0
adel, a_    reverbsc adel, a_, limit(kfb*2, 0, .95), sr / 3

ifftsize    init 4096 
ioverlap    init ifftsize / 4 
iwinsize    init ifftsize 
iwinshape   init 1 ; von-Hann window 

fftin       pvsanal adel, ifftsize, ioverlap, iwinsize, iwinshape 
fftscale    pvscale fftin, kratio, 0, 1
atrans      pvsynth fftscale

; delay the feedback to let it build up over time
afb         vdelay3 atrans, a(ktime*1000), imaxdel
aout         =  ain*(1-kwet) + adel*(1-kfb/4)/2

    xout aout

    endop
;END OPCODE
