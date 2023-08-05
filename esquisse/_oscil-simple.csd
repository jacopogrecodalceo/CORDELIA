<CsoundSynthesizer>

<CsOptions>
-odac
-r=48000
</CsOptions>

<CsInstruments>

nchnls = 2
ksmps = 16
0dbfs = 1
gisaw			ftgen	0, 0, 8192, 7, 1, 8192, -1				; sawtooth wave, downward slope

    instr 1

aout    oscili .015, random:i(1, 3)*400+randomi:k(-100, 100, 1), gisaw

aout    = aout * linseg(0, .005, 1, 1, .15, p3-1-.005, 0)
af    moogladder2 aout, 5500+randomi:k(-3500, 100, 1), .95
aout balance2 af, aout
        outch p4, aout

    endin

indx init 0

until indx > 25 do
    schedule 1, 0, 15, (indx%2)+1
    indx = indx + 1
od

</CsInstruments>

</CsoundSynthesizer>
