import time
import ctcsound as csound
import numpy as np
import soundfile as sf
import os
#from threading import Thread, Event

script_dir = os.path.dirname(os.path.abspath(__file__))
path_soundfile = os.path.join(script_dir, 'output-sf.wav')
path_fout = os.path.join(script_dir, 'output-fout.wav')
duration = 60

system_code = '''
sr = 48000
nchnls = 2
0dbfs = 1
'''

instrument_code = '''
gaouts[] init nchnls

	instr 1

aout oscili .25, 300+randomh:k(-50, 100, 12)
aout *= linseg(0, .05, 1, p3-.1, 1, .05, 0)
	out aout, aout

gaouts[0] = aout
gaouts[1] = aout

	endin

	instr 2

aout[]	init nchnls
aout = gaouts

	fout gSrecording, -1, aout

	endin

'''

cs = csound.Csound()

cs.setOption('-odac')
cs.setOption('-3')

gvar = f'gSrecording init "{path_fout}"'

cs.compileOrc(system_code + gvar + instrument_code)
score = [
	f'i 1 0 {duration}',
	f'i 2 0 {duration}'
]
cs.readScore('\n'.join(score))

cs.start()

sr = int(cs.sr())
channels = int(cs.nchnls())

sig = np.reshape(cs.spout(), (-1, channels))  # Reshape the array

with sf.SoundFile(path_soundfile, 'w', samplerate=sr, channels=channels, subtype='PCM_24') as outfile:
	while True:
		if cs.performKsmps() != 0:
			break
		time.sleep(1/sr)
		outfile.write(sig)
	
cs.cleanup()
del cs

