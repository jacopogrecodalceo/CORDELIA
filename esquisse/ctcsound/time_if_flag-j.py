import sys
import ctcsound
import time
import random

def time_execution(func):
    def wrapper(*args, **kwargs):
        start_time = time.time()
        func(*args, **kwargs)
        end_time = time.time()
        elapsed_time = end_time - start_time
        print(f"Function '{func.__name__}' took {elapsed_time:.6f} seconds to execute.")
        return
    return wrapper

@time_execution
def csound_test():
	orc_text = '''
gisaw	ftgen 0, 0, 8192, 7, 1, 8192, -1

	instr 1

;---STANDARD
ich			init p4
idur = p3

iamp		init 1
ifreq		init 1

kfreq       = random:i(40, 400)
kamp		= abs(jitter(1, .005, .25))

aamp	a  kamp
afreq	a  kfreq*ifreq

i1div2pi		init 1/24

kpeakdev		= aamp * 2 * i1div2pi
kpeakdev2		= aamp * cosseg(3, idur, 5) * i1div2pi

;STEREO "CHORUS" ENRICHMENT USING JITTER
kjitR			jitter cosseg(5, idur, .75), 1.5, 3.5

;MODULATORS
aModulator		oscili	kpeakdev*linseg(0, idur, 1), afreq * 5
aModulator2		oscili	kpeakdev2*cosseg(0, idur, 1), afreq * 2, gisaw

avib1	= lfo(kfreq/64, kfreq/250)*abs(jitter(1, 1/p3, 100/p3))

aCarrierR		phasor	portk(kfreq + kjitR, idur/96, 20)+avib1
aCarrierR		table3	aCarrierR + aModulator + aModulator2, gisaw, 1, 0, 1
aSigR	= aCarrierR * aamp

aFilterR		bqrez	aSigR, afreq+(afreq*(16*aamp)), .75
aout			balance2 aFilterR, aSigR

	outch ich, aout/64

	endin
'''

	sco_text = ''
	for i in range(25):
		sco_text += f'i1 0 35 {(i%2)+1}\n'

	sco_text += 'e'
	cs = ctcsound.Csound()
	cs.setOption("-o1.wav")
	cs.setOption(f'--sample-rate=48000')
	cs.setOption(f'-3')
	cs.setOption(f'--ksmps=8')
	cs.setOption(f'--0dbfs=1')
	cs.setOption(f'--nchnls=2')
	#cs.setOption('--num-threads=8')
    
	cs.compileOrc(orc_text)
	cs.readScore(sco_text)
	cs.start()
	cs.perform()
		
	cs.cleanup()
	cs.reset()
	del cs

csound_test()