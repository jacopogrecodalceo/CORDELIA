import numpy as np
import matplotlib.pyplot as plt
import ctcsound as csound
import threading
import matplotlib.animation as animation
from queue import Queue

# Constants
N_FFT = 4096  # Reduce FFT size for real-time processing
F_MAX_IDX = 500  # Reduce the maximum frequency index for real-time processing
N_PLOT_TF = int(F_MAX_IDX/2)  # Reduce the number of plot time frames for real-time processing
FFT_WINDOW = np.hanning(N_FFT)
OVERLAP = 1 / 4

def setup_plot():
    Hz_min = 0
    Hz_max = 20000
    fig, ax = plt.subplots()
    image = ax.imshow(np.zeros((1, 1)), aspect="auto", origin="lower", extent=[0, N_PLOT_TF, Hz_max, Hz_min])
    ax.set_xlabel("Time frame")
    ax.set_ylabel("Frequency (Hz)")
    ax.set_ylim(Hz_min, Hz_max)
    ax.set_title("Spectrogram")
    fig.colorbar(image, ax=ax, format="%+2.0f dB")
    return fig, ax, image


def setup_csound():
    code = '''
    sr      = 48000
    nchnls  = 2
    0dbfs   = 1
    ksmps   = 8
        instr 1

    aout, a2    diskin "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/alina.wav", 1 
            outall  aout*linseg(0, .05, 1, p3-.05, 0)

        endin
    schedule 1, 0, 25
    '''
    cs = csound.Csound()
    cs.setOption('-odac')
    cs.compileOrc(code)
    cs.start()
    return cs

def audio_processing(cs, sigs_queue, n_fft, f_max_idx, amp):
    buffer = np.zeros(n_fft)
    spout = cs.spout()

    step_size = int(n_fft * (1 - OVERLAP))
    n_frames = N_PLOT_TF + int((N_PLOT_TF - 1) / (1 - OVERLAP))

    while True:
        cs.performKsmps()
        for i in spout:
            sig = i / cs.get0dBFS()
            sigs_queue.put(sig)

        while sigs_queue.qsize() >= n_fft:
            # Get data from the queue for processing
            buffer = np.zeros(n_fft)
            for i in range(n_fft):
                buffer[i] = sigs_queue.get()

            x = buffer.copy()

            # Compute the FFT
            if len(x) < n_fft:
                x = np.pad(x, (0, n_fft - len(x)), 'constant')
            amp[-1] = np.sqrt(np.abs(np.fft.rfft(FFT_WINDOW * x)))[0:f_max_idx]
            amp[0:-1] = amp[1:]

            amp[:-step_size] = amp[step_size:]

def plot_spectrogram(fig, ax, image, amp, vmax, vmin):
    ax.set_title("Spectrogram")
    interval = 25

    def update(frame):
        image.set_clim(vmin, vmax)
        image.set_data(amp.T[::-1])
        ax.set_title(f"fps: {1000.0 / interval:.1f} Hz")
        return image,  # Return the updated image object as a sequence

    ani = animation.FuncAnimation(fig, update, frames=np.arange(0, N_PLOT_TF), interval=interval, blit=True)
    plt.show()


def show_spectrogram(cs):
    amp = np.zeros((N_PLOT_TF, F_MAX_IDX))
    fig, ax, image = setup_plot()
    vmax, vmin = cs.get0dBFS(), 0

    sigs_queue = Queue(maxsize=N_FFT)

    audio_thread = threading.Thread(target=audio_processing, args=(cs, sigs_queue, N_FFT, F_MAX_IDX, amp))
    audio_thread.start()

    plot_spectrogram(fig, ax, image, amp, vmax, vmin)

    audio_thread.join()
    plt.close()

if __name__ == "__main__":
    cs = setup_csound()
    amp = np.zeros((N_PLOT_TF, F_MAX_IDX))
    show_spectrogram(cs)
