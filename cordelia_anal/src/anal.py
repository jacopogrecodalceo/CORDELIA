import librosa
import numpy as np

from const import ORIGINAL_Y, SAMPLE_RATE, N_FFT, HOP
from .export_f import export

# Process with yin algorythm
@export()
def yin_algorithm():
	f0, voicing, voicing_probability = librosa.pyin(y=ORIGINAL_Y, sr=SAMPLE_RATE, fmin=librosa.note_to_hz('B1'), fmax=librosa.note_to_hz('B6'), hop_length=HOP)
	start = librosa.times_like(f0, sr=SAMPLE_RATE, n_fft=N_FFT, hop_length=HOP)
	dyn = np.full_like(start, fill_value=0.95)

	return start, dyn, f0

# Extract harmonic energy from a specified set of harmonics relative to the f0
def extract_harmonic_energy(f0, spectrum_freq, harmonics):
	frequencies = librosa.fft_frequencies(sr=SAMPLE_RATE, n_fft=N_FFT)
	harmonic_energy = librosa.f0_harmonics(spectrum_freq, f0=f0, harmonics=harmonics, freqs=frequencies)

	# Normalize the harmonic energy by dividing by the maximum value
	total_energy = harmonic_energy.sum(axis=0, keepdims=True)
	normalized_harmonic_energy = harmonic_energy / (total_energy + 1e-8)  # Adding a small value to avoid division by zero
	return normalized_harmonic_energy

@export()
def reconst_signal(start, f0, n_harm):

	spectrum_freq = np.abs(librosa.stft(ORIGINAL_Y, n_fft=N_FFT, hop_length=HOP))
	spectrum_freq = librosa.amplitude_to_db(spectrum_freq, ref=np.max)

	harmonics = np.arange(1, n_harm)

	# Ensure f0_synth is not NaN (replace with 0)
	f0_synth = np.nan_to_num(f0)

	# Calculate all frequencies for all harmonics in one step
	freq = f0_synth[:, np.newaxis] * harmonics

	# Calculate all amplitudes for all harmonics in one step
	dyn = extract_harmonic_energy(f0, spectrum_freq, harmonics).T
	
	dyn = dyn[:, 0]
	freq = freq[:, 0]

	return start, dyn, freq


# Synthesize the same utterance with a constant f0 to produce a monotone effect
def synthesize_monotone(pedal_freq, f0, n_harm, spectrum_freq):
	harmonics = np.arange(1, n_harm)

	f_mono = pedal_freq * np.ones_like(f0)
	y_mono = np.zeros_like(ORIGINAL_Y)

	for i, (factor, energy) in enumerate(zip(harmonics, extract_harmonic_energy(f0, spectrum_freq, harmonics))):
		# times
		frequencies = f_mono * factor
		amplitudes = energy
		# length = len(y)
		# Perform sinusoidal synthesis here

	# Return the synthesized monotone signal
	return y_mono
