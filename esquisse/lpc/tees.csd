<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr      = 48000
ksmps   = 32
nchnls  = 2
0dbfs   = 1

gSfile = "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm2.wav"
gSoutput = "/Users/j/Desktop/dps.lpc"
ires    system_i 1, sprintf("lpanal -p 24 -s 48000 \"%s\" \"%s\"", gSfile, gSoutput)


</CsInstruments>
<CsScore>
f 0 2
e
</CsScore>
</CsoundSynthesizer>