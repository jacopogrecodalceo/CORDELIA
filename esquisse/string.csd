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

Sinstr init p4

if strcmp(Sinstr, "piano") == 0 then
    print 1
endif

    endin



</CsInstruments>
<CsScore>
i 1 0 9 "piano"
</CsScore>
</CsoundSynthesizer>