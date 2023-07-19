import ctcsound

from processing_py import *

orc_text = '''
	instr 1
		out(linen(oscili(p4,p5),0.1,p3,0.1))
	endin'''

sco_text = "i1 0 5 1000 440"

cs = ctcsound.Csound()
canvas = App(500, 500)
canvas.colorMode(RGB)

result = cs.setOption("-d")
result = cs.setOption("-odac")
result = cs.compileOrc(orc_text)
result = cs.readScore(sco_text)
result = cs.start()

while True:
		result = cs.performKsmps()
		stream = cs.outputBuffer()
		#gen_spectrum(stream)
		#print(stream)
		canvas.background(color(255,0,0))
		canvas.ellipse(200,200,50,50)

		if result != 0:
			break

result = cs.cleanup()
cs.reset()
del cs
