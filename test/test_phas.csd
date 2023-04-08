<CsoundSynthesizer>
<CsOptions>
-odac0
-+rtaudio=jack
</CsOptions>
<CsInstruments>
0dbfs=1
nchnls=4
sr = 48000

ksmps = 8

		instr COROSC

aph phasor 2
kph k aph
	outch 3, aph


klast	init -1
if klast > kph then
		schedulek 2, .022, .05
endif
klast	= kph


	endin

	instr 2

aout oscili .15*line(1, p3, 0), 350
	outch 1, aout
	outch 2, aout

	endin


</CsInstruments>
<CsScore>
i 1 0 555
e
</CsScore>
</CsoundSynthesizer>
