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
inum init 1
gimax_partials init 31
inum			init ((inum - 1) % gimax_partials) + 1 
print inum
    endin

instr 2
 print gimax_partials
 endin
</CsInstruments>
<CsScore>
i1 0 0
i2 0 0
</CsScore>
</CsoundSynthesizer>
