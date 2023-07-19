import sys
import ctcsound7
import ctypes
import numpy as np

orc_text = '''
  instr 1
	aout = linen(oscili(p4,p5),0.1,p3,0.1)
		chnset aout, "joj"
	outall aout

  endin'''

sco_text = "i1 0 5 1000 440"

cs = ctcsound7.Csound()
cs.setOption('-odac')
cs.setOption('-3')
cs.compileOrc(orc_text)
cs.readScore(sco_text)
result = cs.start()

arr = np.array([], np.int32)

while True:
	result = cs.performKsmps()
	audio = cs.audioChannel('joj', arr)
	print(audio)
	if result != 0:
		break

result = cs.cleanup()
cs.reset()
del cs
sys.exit(result)