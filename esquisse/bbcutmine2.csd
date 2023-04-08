<CsoundSynthesizer>
<CsOptions>
;--port=10000
;--format=float
-3
-m0
-D
;-+msg_color=1
--messagelevel=96
--m-amps=1
--env:SSDIR+=../

</CsOptions>
<CsInstruments>

;sr		=	192000
sr		=	48000

ksmps		=	1	;leave it at 64 for real-time
;nchnls_i	=	12
nchnls		=	2
;A4		=	438	;only for ancient music	
gSfile init "/Users/j/Documents/PROJECTs/CORDELIA/samples/bleu.wav"
gilen filelen gSfile
gifile     		 ftgen 0, 0, 0, 1, gSfile, 0, 0, 0

    instr 1

idiv init 48

p3 init gilen*16

ifreq       init idiv/gilen
idur        init gilen/idiv

kndx      init 0

kvar        init 0

kvar_dur    init 0



k1 init 1
if (kndx % (idiv/8)) == 0 && k1 == 1 then
    kvar += 1/idiv
    k1 = 0
endif

k3 init 1

if (kndx % (idiv*2)) == 0 && k3 == 1 then
    kvar = 0
    k3 = 0
endif

k2 init 1
if (kndx % idiv) == 0 && k2 == 1 then
    kvar_dur += idur*idiv
    k2 = 0
endif

klin linseg 4, p3, 1

if metro:k(ifreq) == 1 then
    schedulek 2, 0, (idur+kvar_dur+.25)/klin, kvar%1
    kndx += 1
    k1 = 1
    k2 = 1
    k3 = 1
    kvar_dur = 0
endif

printk2 kvar_dur

    endin

    instr 2
aph phasor 1/gilen

aout    table3 (aph+p4)%1, gifile, 1

idiv    init 6
aenv    linseg 0, .005, 1, p3-(p3/idiv)-.005, 1, p3/idiv, 0
aenv    *= .5

aout      *= aenv

    outall  aout
 
endin 
</CsInstruments>
<CsScore>

i1 0 1

</CsScore>
</CsoundSynthesizer>