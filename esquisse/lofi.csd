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

kbits       = 2
kfold       linseg 0, p3, 35

ain, a2        diskin "/Users/j/Documents/PROJECTs/CORDELIA/samples/amen.wav", .25

kvalues		pow		2, kbits					    ;RAISES 2 TO THE POWER OF kbitdepth. THE OUTPUT VALUE REPRESENTS THE NUMBER OF POSSIBLE VALUES AT THAT PARTICULAR BIT DEPTH
aout		=	(int((ain/0dbfs)*kvalues))/kvalues	;BIT DEPTH REDUCE AUDIO SIGNAL
aout		fold 	aout, kfold

arev	    nreverb aout, 9, abs(lfo(1, 5/p3))

        outall (aout + arev/4)/2

    endin

</CsInstruments>
<CsScore>

i1 0 15

</CsScore>
</CsoundSynthesizer>