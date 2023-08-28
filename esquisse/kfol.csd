<CsoundSynthesizer>
<CsOptions>
;--port=10000
;--format=float
-3
;-+msg_color=1
--messagelevel=96
--m-amps=1
-odac
</CsOptions>
<CsInstruments>

;sr		=	192000
sr		=	48000
0dbfs   =   1
ksmps = 64
nchnls  =	2

gSdrum init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/amen.wav"
gSfile init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/algo.wav"

    instr 1

adrum, an_ diskin2 gSdrum, 1, 0, 1
afile, an_ diskin2 gSfile, 1, 0, 1

;idt -- This is the period, in seconds, that the average amplitude of asig is reported. If the frequency of asig is low then idt must be large (more than half the period of asig )
aenv follow adrum, 1/32
aout balance2 afile, aenv/8

    outall aout

    endin

</CsInstruments>
<CsScore>
i 1 0 50
</CsScore>
</CsoundSynthesizer>