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

    instr 1

aouts[] init nchnls
aout    sumarray aouts

    endin



</CsInstruments>
<CsScore>
i1 0 1
</CsScore>
</CsoundSynthesizer>