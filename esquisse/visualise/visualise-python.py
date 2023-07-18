import ctcsound
import librosa, librosa.display
import numpy as np
import matplotlib.pyplot as plt

import threading

# Function to process audio and update the stream array
def process_audio():
    global stream
    while True:
        result = cs.performKsmps()
        stream = np.frombuffer(cs.spout(), dtype=np.float32)
        if result != 0:
            break

# Function to update and redraw the spectrogram plot
def update_plot():
    global stream
    while True:
        # Compute the mel spectrogram for the updated stream
        S = librosa.feature.melspectrogram(y=stream, sr=sr)
        
        # Clear the previous plot and create a new figure for the updated spectrogram
        plt.clf()
        plt.title("Real-time Spectrogram")
        librosa.display.specshow(librosa.power_to_db(S, ref=np.max), sr=sr, x_axis='time', y_axis='mel')
        plt.colorbar(format='%+2.0f dB')

        # Pause briefly to allow for real-time display
        plt.pause(0.001)

        if cs.status() != 0:
            break

# Set up Csound and initialize the stream array
cs = ctcsound.Csound()

sr = 48000  # time resolution of the recording device (Hz)

orc_text = '''
instr 1
    out(linen(oscili(p4, p5), 0.1, p3, 0.1))
endin'''

sco_text = "i1 0 5 1000 440"

cs = ctcsound.Csound()

result = cs.setOption("-d")
result = cs.setOption("-odac")
result = cs.compileOrc(orc_text)
result = cs.readScore(sco_text)
result = cs.start()

stream = cs.spout()

# Convert the stream to a NumPy array
stream = np.frombuffer(stream, dtype=np.float32)

# Create and start the audio processing thread
audio_thread = threading.Thread(target=process_audio)
audio_thread.start()

# Create and start the plot update thread
plot_thread = threading.Thread(target=update_plot)
plot_thread.start()

# Wait for both threads to finish
audio_thread.join()
plot_thread.join()


result = cs.cleanup()
cs.reset()
del cs