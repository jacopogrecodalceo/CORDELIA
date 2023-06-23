import librosa
import numpy as np

# Load the audio file
score_file = '/Users/j/Desktop/test.txt'
audio_file = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/bleu.wav'
y, sr = librosa.load(audio_file)

frame_length = 8192

# Estimate the pitch frequency
pitches = librosa.yin(y, fmin=20, fmax=20000, frame_length=frame_length, sr=sr)
times = librosa.frames_to_time(np.arange(len(pitches)), sr=sr, hop_length=frame_length/4)
combined_array = np.column_stack((pitches, times))

with open(score_file, 'w') as f:

    for pitch, time in combined_array:
        # Access time and pitch values as a double element
        string = f"cordelia, {float(time)}, .5, .5, 0, {float(pitch)}\n"
        print(string)
        f.write(string)