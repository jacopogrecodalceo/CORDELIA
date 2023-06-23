import librosa
import matplotlib.pyplot as plt
import numpy as np
import statsmodels.api as sm
from scipy.signal import find_peaks

# Load data and sampling frequency from the data file
data, sampling_frequency = librosa.load('./Tuning fork 1.mp3')

# Get some useful statistics
T = 1/sampling_frequency # Sampling period
N = len(data) # Signal length in samples
t = N / sampling_frequency # Signal length in seconds

auto = sm.tsa.acf(data, nlags=2000)

peaks = find_peaks(auto)[0] # Find peaks of the autocorrelation
lag = peaks[0] # Choose the first peak as our pitch component lag

pitch = sampling_frequency / lag # Transform lag into frequency
