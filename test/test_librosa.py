import librosa
import soundfile as sf

input_s = '/Users/j/Documents/PROJECTs/CORDELIA/samples/armagain.wav'
out_s = '/Users/j/Desktop/livecod.wav'

x = sf.read(input_s)
print(sf.info(input_s))
yt, index = librosa.effects.trim(x, top_db=60)
sf.write(out_s, yt, 48000, subtype='PCM_24')
