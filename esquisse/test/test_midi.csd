<CsoundSynthesizer>
<CsOptions>
--midioutfile="midi.mid" -n

</CsOptions>
<CsInstruments>
0dbfs=1
nchnls=2

ksmps = 32

	instr 1

ktrig metro 1
midion2 1, int(random:k(60, 72)), random:k(50, 95), ktrig

	endin


</CsInstruments>
<CsScore>
i 1 0 25
</CsScore>
</CsoundSynthesizer>
