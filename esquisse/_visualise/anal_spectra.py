import numpy as np
from scipy.io import wavfile
import matplotlib.pyplot as plt

# Load data from WAV file
sample_rate, audio = wavfile.read('/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/algo.wav')

# FFT
# Create an array of equally spaced values representing the time axis
t = np.arange(audio.shape[0])
# Calculate the frequency values corresponding to the FFT result
freq = np.fft.fftfreq(t.shape[-1]) * sample_rate
sp = np.fft.fft(audio)

# Plot spectrum
plt.plot(freq, abs(sp.real), linewidth=.5)
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude')
plt.title('Spectrum of Middle C Recording on Piano')
plt.xlim((0, 20000))
plt.grid(True)
plt.show()
