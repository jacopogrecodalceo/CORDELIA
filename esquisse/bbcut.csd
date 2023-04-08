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
-odac
-+rtaudio=CoreAudio

</CsOptions>
<CsInstruments>

;sr		=	192000
sr		=	48000

ksmps		=	1	;leave it at 64 for real-time
;nchnls_i	=	12
nchnls		=	2
0dbfs		=	1
;A4		=	438	;only for ancient music	


    instr 1

Sfile init "/Users/j/Documents/PROJECTs/CORDELIA/samples/bleu.wav"

a1, a2 diskin Sfile, 1, 0, 1

ilen filelen Sfile

ibpm = 60*ilen
print ilen
print ibpm

;ibpm = 240

ibps = ibpm/60
isubdiv = 4 ;4, 8, 12 ..
ibarlength = 4
iphrasebars = 1
inumrepeats = 4

istutterspeed = 1
istutterchance = 1
ienvchoice = 1

a1        bbcutm a1, ibps, isubdiv, ibarlength, iphrasebars, inumrepeats, istutterspeed, istutterchance, ienvchoice
a2        bbcutm a2, ibps, isubdiv, ibarlength, iphrasebars, inumrepeats, istutterspeed, istutterchance, ienvchoice

;a1        flanger a1, samphold:a(linseg:a(0, p3, ilen/2), metro:k(1/ilen)), .5, ilen
;a2        flanger a2, samphold:a(linseg:a(0, p3, ilen/2), metro:k(1/ilen)), .5, ilen

    outs  a1*.5, a2*.5

    endin
 
</CsInstruments>
<CsScore>

i1 0 75

</CsScore>
</CsoundSynthesizer>