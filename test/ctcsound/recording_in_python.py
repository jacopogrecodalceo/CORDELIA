import ctcsound as csound
import scipy.io.wavfile as wav
import numpy as np

system_code = '''
sr = 48000
nchnls = 2
0dbfs = 1
'''

instrument_code = '''
instr 1
a1 oscili 0.5, 5
a2 oscili a1, 100+randomh:k(-50, 100, 15/p3)

prints gSrecording

outall a1 + a2
endin
'''

cs = csound.Csound()

cs.setOption('-odac')
path = '/Users/j/Desktop/output.wav'
gvar = f'gSrecording init "{path}"'
cs.compileOrc(system_code + gvar + instrument_code)
cs.readScore('i 1 0 15')

cs.start()

spout = cs.spout()

sr = int(cs.sr())
channels = int(cs.nchnls())

sig = np.zeros((0, channels), dtype=np.float32)

while cs.performKsmps() == 0:
    frame = np.array(spout, dtype=np.float32) / cs.get0dBFS()
    frame = frame.reshape(-1, channels)
    sig = np.concatenate((sig, frame))

cs.cleanup()
del cs

wav.write("output.wav", sr, sig)
