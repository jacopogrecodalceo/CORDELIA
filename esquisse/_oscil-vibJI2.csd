<CsoundSynthesizer>

<CsOptions>
-odac0
--sample-rate=48000
</CsOptions>

<CsInstruments>

nchnls = 2
ksmps = 16
0dbfs = 1

gicps_last init 0

	instr 1

	schedule "sine", 0, p3, p4
	print gicps_last

if active:i("sine") > 0 then
	schedule "mark", 0, p3, abs(p4-gicps_last)
endif

	gicps_last init p4

	turnoff
	endin

	instr mark
schedule "mark_instr", 0, .5
print p4
if p4 < 20 then
	if metro:k(p4) == 1 then
		schedulek "mark_instr", 0, .5
	endif
endif
	endin

	instr mark_instr
aout    oscili .05, linseg(120, p3, 40)
aout    = aout * linseg(0, .005, 1, p3-.005, 0)
	outall aout
	endin

	instr sine
icps init p4
aout    oscili .05, icps
aout    = aout * linseg(0, .005, 1, p3-.005, 0)
	outall aout
	endin

</CsInstruments>
<CsScore>
i1 0 10 400
i1 1 10 401
i1 4 10 405
e
</CsScore>

</CsoundSynthesizer>
