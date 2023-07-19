import librosa
import numpy as np

# Load the audio file
audio_file = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/bleu.wav'
score_file = '/Users/j/Desktop/test.txt'
audio_data, sample_rate = librosa.load(audio_file, sr=None)

frame_length = 4096

# Perform pitch detection using the Yin algorithm
pitches = librosa.yin(audio_data, fmin=20, fmax=20000, frame_length=frame_length, sr=sample_rate)


# Get time locations of each pitch
hop_length = 4096
times = librosa.times_like(pitches, sr=sample_rate, hop_length=frame_length/4)

# Combine frequencies and time locations into a single array
pitch_time = np.vstack((times, pitches)).T

# Calculate the differences between consecutive start times
durations = np.diff(pitch_time[:, 0])

# Pad durations array with 0 at the beginning to match the length of pitch_time
durations = np.concatenate(([0], durations))

# Create a new array with durations added to pitch_time
pitch_time_with_duration = np.column_stack((pitch_time, durations))


def filter_consecutive_freq(arr, epsilon=1):
    filtered_arr = []
    prev_frequency = None
    prev_octave = None

    for row in arr:
        time, frequency, duration = row

        rounded_frequency = round(frequency, 6)

        if prev_frequency is None or abs(rounded_frequency - prev_frequency) > epsilon * (2 ** (abs(prev_octave - np.floor(np.log2(frequency / 440)) + 1))):
            filtered_arr.append(row)
            prev_frequency = rounded_frequency
            prev_octave = np.floor(np.log2(frequency / 440)) + 1

    return np.array(filtered_arr)



dyn = '.5'
env = '0'

with open(score_file, 'w') as f:
	
	for time, pitch, dur in filter_consecutive_freq(pitch_time_with_duration):
		# Access time and pitch values as a double element
		string = f"cordelia, {float(time)}, {dur}, {dyn}, {env}, {float(pitch)}\n"
		#print(string)
		f.write(string)


