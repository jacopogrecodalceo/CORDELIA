<CsoundSynthesizer>
<CsOptions>

;--midioutfile="midi.mid" -odac

-Ma
-odac
</CsOptions>
<CsInstruments>
0dbfs=1
nchnls=2

ksmps = 32

	instr 1

;kstatus, kchan, kdata1, kdata2 midiin

;printk2 kstatus
kval chanctrl 1, 120
printk2 kval
	print 1

	endin


</CsInstruments>
<CsScore>
f0 z
i 1 0 25
</CsScore>
</CsoundSynthesizer>
