import ctcsound

import numpy as np

orc_text = '''

		instr 1

	aout	oscili 1000, 500
	aout	*= linseg(0, 1, 1, p3-1, 0)
			outall aout

	karr[] init 1026

	fsig	pvsanal aout, 1024, 256, 1024, 1
	kframe	pvs2tab karr, fsig

		endin'''

sco_text = "i1 0 5"

cs = ctcsound.Csound()
result = cs.setOption("-d")
result = cs.setOption("-odac")
result = cs.compileOrc(orc_text)
result = cs.readScore(sco_text)
result = cs.start()
pyfft = np.empty((1026, 1026))

#print(pyfft)
while True:
	result = cs.performKsmps()
	cs.tableCopyOut('karr', pyfft)
	if result != 0:
		break
result = cs.cleanup()
cs.reset()
del cs
