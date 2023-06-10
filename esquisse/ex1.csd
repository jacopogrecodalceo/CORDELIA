<CsoundSynthesizer>
<CsOptions>
--port=10000
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

print 1

    endin



</CsInstruments>
<CsScore>
i 1 0 -1
</CsScore>
</CsoundSynthesizer>