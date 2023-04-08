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

gSfile               init "/Users/j/Documents/PROJECTs/CORDELIA/samples/etag.wav"
gifile      		 ftgen 0, 0, 0, 1, gSfile, 0, 0, 1

    instr 1

ilen filelen gSfile

kamp = 1
kpitch = 1
kloopend = ilen
kloopstart = 0
kcrossfade = .05

a1      flooper2 kamp, kpitch, kloopstart, kloopend, kcrossfade, gifile, 0, 2
a2      = a1

ibpm = 60*ilen
print ilen
print ibpm

;ibpm = 240

ibps = ibpm/60
isubdiv = 4
ibarlength = 4
iphrasebars = 4
inumrepeats = 8

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