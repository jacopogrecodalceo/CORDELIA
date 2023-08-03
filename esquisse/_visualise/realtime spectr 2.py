import ctcsound
import time
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import threading
import random

from collections import deque


# Set the dark background style for plots
plt.style.use('dark_background')

# Set the desired width and height of the plot in inches
PLOT_W = 15
PLOT_H = 5

N_FFT = 8192
F_MAX_IDX = 480  # 1 < F_MAX_IDX < n_freqs
N_PLOT_TF = 95
VMIN, VMAX = 0, 15
fig, axes = plt.subplots(1, 2, figsize=(PLOT_W, PLOT_H))  # Create two subplots side by side
images = [ax.imshow(np.zeros((N_PLOT_TF, F_MAX_IDX)).T, aspect="auto") for ax in axes]

for i, _ in enumerate(images):
	images[i].set_clim(VMIN, VMAX)

for i, ax in enumerate(axes):
	ax.set_xlabel("Time frame")
	ax.set_ylabel("Frequency")
	ax.set_title(f"Channel {i+1}")

# Update y-axis tick labels for each subplot
for ax in axes:
	ax.set_yticks(np.linspace(0, F_MAX_IDX, 5))
	ax.set_yticklabels([f"{np.fft.rfftfreq(N_FFT, d=1.0 / 48000)[int(tick)]:.0f}" for tick in ax.get_yticks()[::-1]])

# Add text on the right side of the plot
text_x = 0.95  # Adjust this value to control the distance of the text from the right side of the plot
text_y = 0.5   # Adjust this value to control the vertical position of the text

# Create the text object and store it for future updates
text_object = fig.text(text_x, text_y, "Your Initial Text", va='center', ha='center', fontsize=9, color='white')


fig.colorbar(images[0], ax=axes)

class PlotUpdater:
	def __init__(self, images, pretime):
		self.window = np.hamming(N_FFT)
		self.amplitudes = np.zeros((2, N_PLOT_TF, F_MAX_IDX))  # Two channels for stereo audio
		self.freqs = np.fft.rfftfreq(N_FFT, d=1.0 / 48000)
		self.images = images
		self.pretime = pretime
		self.chunk = deque(maxlen=N_FFT)

	def setup_csound(self):
		code = '''
		sr      = 48000
		nchnls  = 2
		0dbfs   = 1
		ksmps   = 64
			instr 1

		kinst active 1

		a1  oscili abs(jitter(1, .5, 1))*1/kinst, 100*int(abs(jitter(1, .5, 1))*25)
		a2	oscili abs(jitter(1, .5, 1))*1/kinst, 100*int(abs(jitter(1, .5, 1))*25)
			outs a1, a2

			endin
		'''

		for _ in range(2):
			code += f'schedule 1, 0, {random.randint(15, 35)}\n'

		cs = ctcsound.Csound()
		cs.setOption('-odac')
		cs.compileOrc(code)
		self.block_size = cs.ksmps()
		self.channels = cs.nchnls()
		self.block = np.zeros((self.block_size, self.channels))
		return cs

	def update_plot(self, frame):

		if len(self.chunk) >= N_FFT:
			block = np.array(self.chunk)[:N_FFT]
			block = block.reshape((-1, self.channels))

			for i in range(self.channels):  # Process each channel separately
				x = block[:, i]
				self.amplitudes[i, -1] = np.sqrt(np.abs(np.fft.rfft(x)))[0:F_MAX_IDX]
				self.images[i].set_data(self.amplitudes[i].T[::-1])

			self.amplitudes[:, 0:-1] = self.amplitudes[:, 1::]

		curtime = time.time()
		time_diff = curtime - self.pretime
		fps = 1.0 / (time_diff + 1e-16)
		text_object.set_text(f"fps: {fps:0.1f} Hz")
		self.pretime = curtime
		self.chunk.clear()

	def csound_performance(self, cs):
		cs.start()
		while cs.performKsmps() == 0:
			self.block = np.array([i / cs.get0dBFS() for i in cs.spout()])
			self.chunk.extend(self.block)
		cs.cleanup()

def main():

	plot_updater = PlotUpdater(images, time.time())  # Adjust block_size and channels for lower ksmps
	csound_instance = plot_updater.setup_csound()

	csound_thread = threading.Thread(target=plot_updater.csound_performance, args=(csound_instance,))
	csound_thread.start()

	# Create the animation
	animation = FuncAnimation(fig, plot_updater.update_plot, interval=50, save_count=50)

	# Show the plot
	plt.show()

	csound_thread.join()  # Wait for the csound_thread to finish before exiting the main thread.

if __name__ == "__main__":
	main()
