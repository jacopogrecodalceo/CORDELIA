<CsoundSynthesizer>

<CsOptions>
-odac0
--sample-rate=48000
</CsOptions>

<CsInstruments>

nchnls = 2
ksmps = 16
0dbfs = 1

	instr 1
idur init 10
	schedule 11, 0, idur
	schedule 10, 0, idur, p4
	schedule 10, 2, idur, p5
	schedule 10, 2, idur, p6
	turnoff
	endin

gkcps init 0

	instr 10

icps init p4

aout    oscili .05, icps

aout    = aout * linseg(0, .005, 1, p3-.005, 0)
	outall aout

icps_init i gkcps
if icps_init != 0 then
	gkcps = abs(icps_init-icps)
else
	gkcps init icps
endif
	endin



	instr 11

ktrig init 1
schedule 12, 0, .5
printk2 gkcps
if gkcps < 20 then
	ktrig metro gkcps-1
	if ktrig == 1 then
		schedulek 12, 0, .5
	endif
endif
	endin

	instr 12

aout    oscili .05, linseg(120, p3, 40)

aout    = aout * linseg(0, .005, 1, p3-.005, 0)
	outall aout

	endin


</CsInstruments>
<CsScore>
i1 0 1 400 401 403
e
</CsScore>

</CsoundSynthesizer>
