<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
0dbfs=1
nchnls=2

ksmps = 8

	instr 1

gktime metro .45
	endin



	instr 3

iprd = 0.01
imindur = 0.1
imemdur = 3
ihp = 1
ithresh = 30
ihtim = 0.005
ixfdbak = 0.05
istartempo = 110
ifn = 1

ktemp tempest gktime, iprd, imindur, imemdur, ihp, ithresh, ihtim, ixfdbak, istartempo, ifn
printk2 ktemp
	endin

</CsInstruments>
<CsScore>
i 1 0 155
i 3 0 155
</CsScore>
</CsoundSynthesizer>
