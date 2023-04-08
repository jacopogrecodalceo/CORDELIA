<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
0dbfs=1
nchnls=2
ksmps = 4096



	instr 1

if metro:k(.25)==1 then
	kval = random:k(1, 5)
endif

kp portk kval, .05
	printk2 kp

	endin



</CsInstruments>
<CsScore>
i 1 0 555
</CsScore>
</CsoundSynthesizer>
