import ctcsound as csound
cs = csound.Csound()

# CSOUND INIT
orc = '''
0dbfs = 1
sr = 48000
ksmps = 16
nchnls = 2

	instr 1

aout	oscili .5, 300
		outall	aout*linseg(0, .05, 1, p3-.05, 0)
	endin
    
'''
sco = "i 1 0 50\n"

cs.setOption('-odac')
cs.compileOrc(orc)
cs.readScore(sco)
result = cs.start()

while True:
    result = cs.performKsmps()
    if result != 0:
        break
result = cs.cleanup()
cs.reset()