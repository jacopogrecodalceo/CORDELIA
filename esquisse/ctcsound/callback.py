import sys
import ctcsound
import time
import ctypes


orc_text = '''
  instr 1
	out(linen(oscili(p4,p5),0.1,p3,0.1))
	gkvar random 1, 2
  endin'''

sco_text = "i1 0 .5 1000 440"

cs = ctcsound.Csound()
cs.createMessageBuffer(False)

cs.setOption("-d")
cs.setOption("-odac")
cs.compileOrc(orc_text)
cs.readScore(sco_text)
cs.start()

while cs.performKsmps() == 0:
  string = cs.firstMessage()
  # Set the custom performance callback
  with open('/Users/j/Desktop/1.txt', 'a') as f:
    if string:
      f.write(string)
  cs.popFirstMessage()

cs.destroyMessageBuffer()
cs.cleanup()
cs.reset()
