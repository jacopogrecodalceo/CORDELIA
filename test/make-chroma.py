import librosa

audio_path = '/Users/j/Documents/PROJECTs/CORDELIA/_score/cor230325-1610.wav'
y, sr = librosa.load(audio_path)
y_harmonic, y_percussive = librosa.effects.hpss(y)

unebarque = Tonal_Fragment(y_harmonic, sr)
unebarque.chromagram("cor230325")