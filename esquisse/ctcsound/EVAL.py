import sys
import ctcsound, subprocess

orc_text = '''
  instr 1
	out(linen(oscili(p4,p5),0.1,p3,0.1))
  endin'''

sco_text = "i1 0 1 1000 440"

cs = ctcsound.Csound()
cs.setOption("-odac")
cs.compileOrc(orc_text)
cs.readScore(sco_text)

cs.start()
t = cs.perform()
print(t)
while True:
	if t == 2:
		print('evaluation')
		print(t)
		subprocess.Popen(['open', '-a', 'Terminal'])
		break

cs.cleanup()
cs.reset()
del cs
