import ctcsound, librosa

import numpy as np


CHUNK = 96000 # number of data points to read at a time
RATE = 16000 # time resolution of the recording device (Hz)

orc_text = '''
	instr 1
		out(linen(oscili(p4,p5),0.1,p3,0.1))
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
		stream = cs.outputBuffer()
		#gen_spectrum(stream)
		#print(stream)
		audio_data = np.fromstring(stream, np.int32)
		S = librosa.feature.melspectrogram(audio_data.astype('int24'), sr=RATE)

		if result != 0:
			break

result = cs.cleanup()
cs.reset()
del cs
