import librosa
from pathlib import Path

# CONSTANTs
N_FFT = 4096
HOP = N_FFT // 16

# LOAD
audio_file = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/etag2.wav'

BASENAME = Path(audio_file).stem
#OUTPUT_DIR = Path(audio_file).parent
OUTPUT_DIR = Path('/Users/j/Desktop')
INSTR = 1

ORIGINAL_Y, SAMPLE_RATE = librosa.load(audio_file, sr=None, mono=True)
ORIGINAL_Y = librosa.util.normalize(ORIGINAL_Y)
