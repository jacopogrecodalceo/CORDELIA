<CsoundSynthesizer>

<CsOptions>
-odac
-r=48000
</CsOptions>

<CsInstruments>

nchnls = 2
ksmps = 16
0dbfs = 1


gSfile init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/SD808/SD1050.wav"
gaout init 0
    instr 1

if metro:k(1) == 1 then
    schedulek 2, 0, 1
endif
schedule 3, 0, p3
    endin

    instr 2

icps random 300, 500

aout pluck random:i(.25, .5), icps+jitter(1, .25, 1), icps, 0, 1
aout *= linseg(1, p3/2, 0)
gaout = aout
    endin

    instr 3

aout convolve gaout/8, gSfile, 0, 1
    outall aout

    endin

</CsInstruments>
<CsScore>
i 1 0 10
</CsScore>

</CsoundSynthesizer>
