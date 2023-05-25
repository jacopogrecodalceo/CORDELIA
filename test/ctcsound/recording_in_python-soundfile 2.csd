<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr		= 48000
nchnls	= 2
0dbfs	= 1

gSrecording init "/Users/j/Desktop/trec.wav"
gaouts[] init nchnls

	instr 1

aout oscili .25, 300+randomh:k(-50, 100, 12)
aout *= linseg(0, .05, 1, p3-.1, 1, .05, 0)
	out aout, aout

gaouts[0] = aout
gaouts[1] = aout

	endin

	instr 2

aout[]	init nchnls
aout = gaouts

	fout gSrecording, -1, aout

	endin

</CsInstruments>
<CsScore>
i 1 0 30
i 2 0 30
</CsScore>
</CsoundSynthesizer>
