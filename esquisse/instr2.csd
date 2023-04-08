<CsoundSynthesizer>
<CsOptions>
-3
-m0
-D
--messagelevel=96
--m-amps=1
--env:SSDIR+=../
-+rtaudio=CoreAudio
--sample-rate=48000
--ksmps=64
--nchnls=2
</CsOptions>
<CsInstruments>

;here to be replaced
sr		    =	48000
ksmps		=	64
nchnls		=	2
0dbfs		=	1

ginchnls            init nchnls

;declare master audio array
gamouth[]           init ginchnls

;declade instr audio array
gaesq[]             init ginchnls



indx	init 0
until	indx == ginchnls do 
    schedule "esq", 1, 5, 1, 1, 200*(1+indx), indx+1
    schedule nstrnum("esq_route")+((indx+1)/1000), 0, -1, indx
	indx	+= 1
od
    ;schedule "esq", 1, 5, 1, 1, 200*(1), 0

    schedule 900, 0, -1
    schedule 910, 0, -1

    event_i "e", 0, 10



	instr esq

Sinstr      nstrstr p1
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

/*
BEGIN
*/

aout		vco2 iamp/4, icps

/*
END
*/

aout        *=linseg:a(0, .15, 1, p3-.15, 0)

if ich != 0 then
    gaesq[ich-1] = aout
else
    gaesq = aout
endif


	endin



   opcode  flingj, a, akk
ain, kdel, kfb xin

aout    moogladder ain, kdel, kfb

    xout aout

    endop



    instr esq_route

ich         init p4

ain         = gaesq[ich]

a1       flingj ain, 2500, .95
a2       flingj a1, 500, .95

gamouth[ich]     = a1 + ain

    endin



    instr 900

aout[]      init ginchnls

aout        = gamouth

    out aout

    endin

    instr 910

    ;clear gamouth
    ;clear gaesq

    endin



</CsInstruments>
<CsScore>
f 0 z
</CsScore>
</CsoundSynthesizer>