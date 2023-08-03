import librosa
import librosa.display
import numpy as np
import matplotlib.pyplot as plt

from const import ORIGINAL_Y, N_FFT, HOP, SAMPLE_RATE

def show_plot(start, f0):
	width_cm = 40
	height_cm = 15

	spectrum_freq = np.abs(librosa.stft(ORIGINAL_Y, n_fft=N_FFT, hop_length=HOP))
	spectrum_freq = librosa.amplitude_to_db(spectrum_freq, ref=np.max)

	fig, ax = plt.subplots()
	fig.set_size_inches(width_cm / 2.54, height_cm / 2.54)

	img = librosa.display.specshow(spectrum_freq, x_axis='time', y_axis='log', ax=ax, sr=SAMPLE_RATE, hop_length=HOP)
	ax.set(title='pYIN fundamental frequency estimation')
	ax.plot(start, f0, label='f0', color='cyan', linewidth=3)
	plt.show()
