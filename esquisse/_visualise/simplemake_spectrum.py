import librosa
import librosa.display
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np
import concurrent.futures
import time

# Record the start time
start_time = time.time()

audio_file = '/Users/j/Desktop/envol-t/sonvs/0-1-intro-4ch-01-piano.wav'
y, sr = librosa.load(audio_file, mono=False)
channels = y.shape[0]

# Tune these parameters for your specific needs
n_fft = 2048
hop_length = n_fft // 8

def plot_spectrogram(channel):
	D = librosa.stft(y[channel], n_fft=n_fft, hop_length=hop_length)
	S_db = librosa.amplitude_to_db(np.abs(D), ref=np.max)
	return S_db

def find_nearest_values(arr1, arr2):
	"""
	Find the nearest values in arr1 to the values in arr2 without repetition.

	Parameters:
	- arr1: NumPy array
	- arr2: NumPy array containing values to search for in arr1.

	Returns:
	- nearest_values: NumPy array of nearest values from arr1 to arr2 without repetition.
	"""
	# Calculate absolute differences between all values in arr1 and arr2
	abs_diff = np.abs(arr1[:, np.newaxis] - arr2)

	# Find the index of the minimum absolute difference for each column
	nearest_indices = np.argmin(abs_diff, axis=0)

	# Get the nearest values from arr1 using the indices
	nearest_values = arr1[nearest_indices]

	# Remove duplicate values, if any
	nearest_values = np.unique(nearest_values)

	return nearest_values

def detect_onset(y, sr):
	o_env = librosa.onset.onset_strength(y=y, sr=sr)
	onset_times = librosa.times_like(o_env, sr=sr)
	onset_frames = librosa.onset.onset_detect(onset_envelope=o_env, sr=sr)
	return onset_times[onset_frames]

# Process channels in parallel
with concurrent.futures.ThreadPoolExecutor() as executor:
	spectrograms = list(executor.map(plot_spectrogram, range(channels)))

# Create subplots and plot the spectrograms
width = 2048
height = width // 2
dpi = width / (height / 25.4)

fig, ax = plt.subplots(nrows=channels, dpi=dpi, figsize=(width // dpi, height // dpi))
plt.subplots_adjust(hspace=5 // dpi)

for channel, S_db in enumerate(spectrograms):
	librosa.display.specshow(S_db, x_axis='time', y_axis='log', ax=ax[channel], cmap=plt.get_cmap('viridis'))
	ax[channel].set_axis_off()
	ax[channel].vlines(find_nearest_values(detect_onset(y[channel], sr), np.arange(0, width, 5, dtype=np.uint16)), 0, height, color='w', alpha=1)

plt.savefig('/Users/j/Desktop/make_spectrum.png', bbox_inches='tight', pad_inches=0, dpi=dpi)
# Record the end time
end_time = time.time()

# Calculate the elapsed time
elapsed_time = end_time - start_time

print(f"Processing time: {elapsed_time:.2f} seconds")