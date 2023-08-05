<CsoundSynthesizer>
<CsOptions>
-odac
-r=48000
</CsOptions>
<CsInstruments>

nchnls = 2
ksmps = 1
0dbfs = 1

    instr 1
indx = 1
until indx > 31 do
  prints "Value of i: %i\n", indx
  indx += 1
od
    endin

</CsInstruments>
<CsScore>
i1 0 0
</CsScore>
</CsoundSynthesizer>
