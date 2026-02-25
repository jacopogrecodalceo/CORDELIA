
;START CORE

; PARAM_1 String
PARAM_2	init 95
PARAM_3	init .5 ; mix
PARAM_4	init 30 ; min
PARAM_5	init 13.5$k ; max


PARAM_OUT cordelia_vocoder PARAM_IN, PARAM_1, PARAM_2, PARAM_3, PARAM_4, PARAM_5, ich

;END CORE

;START INPUT
Skkkk
;END INPUT


;START OPCODE
    opcode cordelia_vocoder, a, aSkkkkipp
ain, Sinstr, kq, kwet, kmin, kmax, ich, iband, icount xin

iband init 24
adest   chnget sprintf("%s_%i", Sinstr, ich)

if kmax < kmin then
    ktmp = kmin
    kmin = kmax
    kmax = ktmp
endif

if kmin == 0 then 
    kmin = 1
endif

if (icount >= iband) goto bank
aband   cordelia_vocoder ain, Sinstr, kq, kwet, kmin, kmax, ich, iband, icount + 1

bank:
    kfreq = kmin*(kmax/kmin)^((icount-1)/(iband-1))
    ;kfreq tab icount - 1, giFrqTable
    kbw = kfreq/kq
    an  butterbp  ain, kfreq, kbw
    an  butterbp  an, kfreq, kbw
    as  butterbp  adest, kfreq, kbw
    as  butterbp  as, kfreq, kbw
    ao  balance as, an

aout = ao + aband

aout	    = aout*kwet + ain*(1-kwet)

xout aout
    endop


;END OPCODE

