import numpy as np
import pyaudio
import librosa
import librosa.display
import matplotlib.pyplot as plt
import time
import threading

# Function to get the audio stream from the microphone
def get_audio_stream(rate, chunk_size):
    p = pyaudio.PyAudio()
    stream = p.open(
        format=pyaudio.paFloat32,
        channels=1,
        rate=rate,
        input=True,
        input_device_index=1,
        frames_per_buffer=chunk_size
    )
    return stream

# Function to plot the Mel spectrogram
def plot_mel_spectrogram(frames, rate):
    pwr_to_db = librosa.core.power_to_db

    # Concatenate audio chunks and compute STFT
    audio_data = np.hstack(frames)
    stft = librosa.stft(audio_data, n_fft=2048, hop_length=512, win_length=2048)
    norm_melspec = pwr_to_db(stft, ref=np.max)

    # Display the Mel spectrogram
    librosa.display.specshow(norm_melspec)
    plt.colorbar(format='%+2.0f dB')
    plt.title('Mel spectrogram')
    plt.show()

def plot_process(frames, rate):
    while True:
        time.sleep(1/9)  # Adjust the time interval as needed
        if frames:
            plot_mel_spectrogram(frames, rate)

def main():
    global frames
    rate = 16000
    chunk_size = rate // 4
    frames = []
    stream = get_audio_stream(rate, chunk_size)

    # Start the plotting thread
    plot_process(frames, rate)
    
    while True:
        start = time.time()
        data = stream.read(chunk_size)
        data = np.frombuffer(data, dtype=np.float32)

        frames.append(data)

        if len(frames) > 20:
            frames.pop(0)

        t = time.time() - start
        print(1 / t)

if __name__ == "__main__":
    main()
