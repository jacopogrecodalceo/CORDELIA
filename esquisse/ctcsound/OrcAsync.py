import ctcsound
import time


orc_1 = '''
giatno		hc_gen 0, 8192, 0, \ 
		hc_segment(1/37, 1, hc_hanning_curve()), \ 
		hc_segment(10/37, 0.52395, hc_diocles_curve(0.95561)), \ 
		hc_segment(23/37, 0, hc_toxoid_curve(1.63835))

'''

orc_2 = '''
gitab ftgen 0, 0, 0, 1, "/Users/j/Documents/PROJECTs/sequenze/0502/7-blanch_bushy/blanch_bushy-cordelia_render/_main/blanch_bushy-_main.wav", 0, 0, 1
'''

orc_3 = '''
	instr 1
	
a1 oscili 1/8, 300, giatno
a2 tablei phasor:a(1/(ftlen(gitab)/48000)), gitab, 1
aout = a1 + a2

aout *= linseg(0, .05, 1, p3-.05, 0)

	outall aout
	
	endin
    schedule 1, 0, 5
'''

orc_text = [orc_2, orc_3]

cs = ctcsound.Csound()
cs.setOption('-odac')
cs.setOption('--nchnls=2')
cs.setOption('--realtime')
cs.setOption('--0dbfs=1')
cs.setOption('--sample-rate=48000')
cs.setOption('--ksmps=16')

#cs.compileOrc('\n'.join(orc_text))

cs.start()
index = 0
flag1 = True
flag2 = True
while True:
    result = cs.performKsmps()
    if index > 2e3 and flag1:
        retval = cs.evalCode(orc_1)
        print(retval)
        flag1 = False
    elif index > 5e3 and flag2:
        cs.compileOrcAsync('\n'.join(orc_text))
        flag2 = False
        index = 0
    else:
        index += 1

    if result != 0:
        break


cs.cleanup()
cs.reset()
del cs
