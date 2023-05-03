import sys
import ctcsound

orc_text = '''
  instr 1
	out(linen(oscili(p4,p5),0.1,p3,0.1))
	gkvar random 1, 2
	;printk2 gkvar
  endin'''

sco_text = "i1 0 5 1000 440"

cs = ctcsound.Csound()
result = cs.setOption('-odac')
result = cs.compileOrc(orc_text)
result = cs.readScore(sco_text)
result = cs.start()
cs.createGlobalVariable('gkvar', 4)
while True:
	result = cs.performKsmps()
	global_var_ptr = cs.queryGlobalVariable('gkvar')
	print(global_var_ptr)
	if result != 0:
		break
	
result = cs.cleanup()
cs.reset()
del cs
sys.exit(result)