import ctcsound

orc = '''
    instr 1

aout oscili .25, p4
    outall aout

    endin
'''

sco = []
for i in range(1, 10):
    sco.append(f'i 1 0 {.25*i} {100*i}')

score_string = '\n'.join(sco)
print(score_string)
cs = ctcsound.Csound()

cs.setOption('-odac')
cs.setOption('--nchnls=2')
cs.setOption('--0dbfs=1')
cs.setOption('--sample-rate=48000')
cs.setOption('--ksmps=16')

cs.compileOrc(orc)
cs.readScore(score_string)

cs.start()
cs.perform()
cs.cleanup()
cs.reset()
del cs
