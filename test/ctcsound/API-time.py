import sys
import ctcsound
import time

orc_text = '''
  instr 1
	out(linen(oscili(p4,p5),0.1,p3,0.1))
	gkvar random 1, 2
	printk2 gkvar
  endin'''

sco_text = "i1 0 5 1000 440"

cs = ctcsound.Csound()
result = cs.setOption("-d")
result = cs.setOption("-odac")
result = cs.compileOrc(orc_text)
result = cs.readScore(sco_text)
result = cs.start()
while True:
	result = cs.performKsmps()
	elapsed_time = cs.scoreTime()
	#print(cs.scoreTime())
	if elapsed_time%.25 > 0:
		print(cs.env('gkvar', withCsoundInstance=False))
		elapsed_time = cs.scoreTime()
	#time.sleep(.5)
	if result != 0:
		break
	
result = cs.cleanup()
cs.reset()
del cs
sys.exit(result)