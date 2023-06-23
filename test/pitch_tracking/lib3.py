import librosa

score_file = '/Users/j/Desktop/test.txt'

filename = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/armagain.wav'
x, sr = librosa.load(filename)

pitches, mags = librosa.piptrack(y=x, sr=sr)

# Get the time values in seconds
times = librosa.frames_to_time(range(pitches.shape[1]), sr=sr)

# Initialize variables
current_pitch = None
current_pitch_start_time = None
current_pitch_magnitude_sum = 0.0

# Iterate over each frame
for t in range(pitches.shape[1]):
    pitch = pitches[:, t]
    magnitude = mags[:, t]
    
    if current_pitch is None:
        if pitch.any():
            current_pitch = pitch
            current_pitch_start_time = times[t]
            current_pitch_magnitude_sum = magnitude.sum()
    else:
        if pitch.any():
            if not (pitch == current_pitch).all():
                pitch_duration = times[t] - current_pitch_start_time
                print(f"Pitch: {current_pitch}, Duration: {pitch_duration:.2f} seconds, Magnitude Sum: {current_pitch_magnitude_sum}")
                current_pitch = pitch
                current_pitch_start_time = times[t]
                current_pitch_magnitude_sum = magnitude.sum()
        else:
            pitch_duration = times[t] - current_pitch_start_time
            print(f"Pitch: {current_pitch}, Duration: {pitch_duration:.2f} seconds, Magnitude Sum: {current_pitch_magnitude_sum}")
            current_pitch = None
