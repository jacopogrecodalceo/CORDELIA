import seaborn
import numpy as np, scipy
import matplotlib.pyplot as plt
import librosa, librosa.display

plt.rcParams['figure.figsize'] = (14, 5)

filename = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/bleu.wav'
x, sr = librosa.load(filename)

bins_per_octave = 36
cqt = librosa.cqt(x, sr=sr, n_bins=300, bins_per_octave=bins_per_octave)
log_cqt = librosa.amplitude_to_db(np.abs(cqt))

librosa.display.specshow(log_cqt, sr=sr, x_axis='time', y_axis='cqt_note', 
                         bins_per_octave=bins_per_octave)
#plt.show()

hop_length = 100
onset_env = librosa.onset.onset_strength(y=x, sr=sr, hop_length=hop_length)

onset_samples = librosa.onset.onset_detect(y=x,
                                           sr=sr, units='samples', 
                                           hop_length=hop_length, 
                                           backtrack=False,
                                           pre_max=20,
                                           post_max=20,
                                           pre_avg=100,
                                           post_avg=100,
                                           delta=0.2,
                                           wait=0)

onset_boundaries = np.concatenate([[0], onset_samples, [len(x)]])
onset_times = librosa.samples_to_time(onset_boundaries, sr=sr)

librosa.display.waveshow(x, sr=sr)
plt.vlines(onset_times, -1, 1, color='r')
#plt.show()

def estimate_pitch(segment, sr, fmin=20.0, fmax=20000.0):
    # Compute autocorrelation of input segment.
    r = librosa.autocorrelate(segment)
    
    # Define lower and upper limits for the autocorrelation argmax.
    i_min = sr/fmax
    i_max = sr/fmin
    r[:int(i_min)] = 0
    r[int(i_max):] = 0
    
    # Find the location of the maximum autocorrelation.
    i = r.argmax()
    f0 = float(sr)/i
    return f0


for i in range(len(onset_boundaries)-1):
    n0 = onset_samples[i]
    n1 = onset_samples[i+1]
    f0 = estimate_pitch(x[n0:n1], sr)
    print(f0)