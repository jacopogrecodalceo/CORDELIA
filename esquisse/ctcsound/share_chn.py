import ctcsound
cs = ctcsound.Csound()

csd = '''
<CsoundSynthesizer>

<CsOptions>
-odac
</CsOptions>

<CsInstruments>
sr     = 48000
ksmps  = 8192
nchnls = 2
0dbfs  = 1

	instr 1
	
aout oscili .4, 400
chnset random:k(1, 4), "pch"

	chano     aout, 3
	endin 

</CsInstruments>
<CsScore>
f 0 z
i 1 0 2
</CsScore>
</CsoundSynthesizer>
'''

cs.compileCsdText(csd)
cs.setHostImplementedAudioIO(True, 8192)
cs.start()
pointer, err = cs.listChannels()
print(pointer)
print(err)
pt = ctcsound.CsoundPerformanceThread(cs.csound())
pt.play()
while pt.status() == 0:	
	pass
	print(cs.controlChannel('pch'))
