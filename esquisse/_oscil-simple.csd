<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

nchnls = 2
0dbfs=1
instr 1
 a1 = oscili(p6,p7)
 out(oscili(a1+p4,p5),a1)
endin
schedule(1,0,1,0dbfs/2,100,0dbfs/2,5)

</CsInstruments>
</CsoundSynthesizer>
