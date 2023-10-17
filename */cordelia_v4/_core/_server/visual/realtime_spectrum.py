import time
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from collections import deque
from csound import CORDELIA_NCHNLS, CORDELIA_SR
import threading

def init_spectrum():
    # Set the dark background style for plots
    plt.style.use('dark_background')

    # Set the desired width and height of the plot in inches
    PLOT_W = 15
    PLOT_H = 5

    # Number of points for FFT (Fast Fourier Transform)
    N_FFT = 8192

    N_FFT_CH = N_FFT*CORDELIA_NCHNLS

    # Maximum index of frequency to display
    F_MAX_IDX = int(N_FFT/4)  # 1 < F_MAX_IDX < n_freqs

    # Number of time frames to plot
    N_PLOT_TF = 50
    VMIN, VMAX = 0, 1

    # Create a Hamming window for FFT processing
    WINDOW = np.hanning(N_FFT)

    # Create the figure and axes for subplots
    fig, axes = plt.subplots(1, CORDELIA_NCHNLS, figsize=(PLOT_W, PLOT_H))
    # Create images for each subplot to display the spectrogram
    images = [ax.imshow(np.zeros((N_PLOT_TF, F_MAX_IDX)).T, aspect="auto") for ax in axes]

    # Set the color limits for the images
    for i, _ in enumerate(images):
        images[i].set_clim(VMIN, VMAX)

    # Set labels and titles for each subplot
    for i, ax in enumerate(axes):
        ax.set_xlabel("Time frame")
        ax.set_ylabel("Frequency")
        ax.set_title(f"Channel {i + 1}")

    # Update y-axis tick labels for each subplot to display corresponding frequencies
    for ax in axes:
        ax.set_yticks(np.linspace(0, F_MAX_IDX, 5))
        ax.set_yticklabels([f"{np.fft.rfftfreq(N_FFT, d=1.0 / CORDELIA_SR)[int(tick)]:.0f}" for tick in ax.get_yticks()[::-1]])

    # Add text on the right side of the plot to show frames per second (FPS)
    text_x = 0.95  # Adjust this value to control the distance of the text from the right side of the plot
    text_y = 0.5   # Adjust this value to control the vertical position of the text

    # Create the text object and store it for future updates
    text_object = fig.text(text_x, text_y, "FPS", va='center', ha='center', fontsize=9, color='white')

    # Add a colorbar to the first subplot
    fig.colorbar(images[0], ax=axes)



# Function to update the plot with new data
def update_plot(frames, amplitudes, images, chunk, pretime):
    if len(chunk) >= N_FFT_CH:
        # Extract a chunk of audio data with the size of N_FFT from the chunk buffer
        block = np.array(chunk)[:N_FFT_CH]
        # Reshape the block into a 2D array, separating channels (stereo) if needed
        block = block.reshape((-1, CORDELIA_NCHNLS))

        # Process each channel separately
        for i in range(CORDELIA_NCHNLS):
            # Extract the audio data for the current channel 'i'
            x = block[:, i]
            # Apply a Hamming window to the audio data and compute its magnitude spectrum
            amplitudes[i, -1] = np.abs(np.fft.rfft(WINDOW * x))[:F_MAX_IDX]
            # Update the data of the corresponding image (spectrogram) for the current channel 'i'
            images[i].set_data(amplitudes[i].T[::-1])

        # Shift the stored amplitudes to the left to make space for the new data
        amplitudes[:, :-1] = amplitudes[:, 1:]

        # Clear the chunk buffer to receive new audio data
        chunk.clear()

    # Calculate the current time and time difference since the last update
    curtime = time.time()
    time_diff = curtime - pretime
    # Calculate frames per second (FPS) with a minimum value of 1e-16 to avoid division by zero
    fps = 1.0 / (time_diff + 1e-16)
    # Update the text object in the plot to display the FPS
    text_object.set_text(f"fps: {fps:0.2f} Hz")
    # Update the pretime for the next iteration
    pretime = curtime

# Function to continuously update audio data
def update_audio(spout, chunk):
    while True:
        block = np.array([i / 1 for i in spout])
        chunk.extend(block)
        time.sleep(10 / CORDELIA_SR)

# Function to display the spectrogram
def show_spectrogram(spout):
    chunk = deque(maxlen=N_FFT_CH)
    amplitudes = np.zeros((CORDELIA_NCHNLS, N_PLOT_TF, F_MAX_IDX))  # Two channels for stereo audio

    pretime = time.time()

    audio_thread = threading.Thread(target=update_audio, args=(spout, chunk), daemon=True)
    audio_thread.start()
    interval = 50
    animation = FuncAnimation(fig, update_plot, fargs=(amplitudes, images, chunk, pretime), interval=interval, save_count=50)

    # Show the plot
    plt.show()
