<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
0dbfs=1
nchnls=2

ksmps = 8192

	instr 1

if p(4) > 0 then
	ich init p4
else
	ich init 1
endif

if ich < nchnls then
	schedule p1, 0, 1, ich + 1
endif

print ich

outch ich, oscili:a(.25, 300)

	endin


</CsInstruments>
<CsScore>
i 1 0 1
</CsScore>
</CsoundSynthesizer>
