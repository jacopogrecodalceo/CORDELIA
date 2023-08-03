import numpy as np
import matplotlib.pyplot as plt
import soundfile as sf
from scipy.integrate import odeint

def linear(y, t):
	x, v = y
	dxdt = v
	dvdt = 0  # Since we want a linear polynomial, the derivative of `b` is zero
	return [dxdt, dvdt]

def diocles(y, t):
	x, v = y
	dxdt = v
	dvdt = 2 * x * (1 - x**2)
	return [dxdt, dvdt]

def brachistochrone(y, t):
	x, v = y
	dxdt = np.sqrt(2 / (1 - x)) * v
	dvdt = -np.sqrt(1 - x**2)
	return [dxdt, dvdt]

def gen_curve(*args):
	dur = 8192
	sample_rate = 48000

	segments = []
	for arg in args:
		start_val = segments[-1][-1] if segments else 0
		seg_dur = int(arg[0] * dur)
		end_val = arg[1]
		seg_type = arg[2]

		if seg_type in globals():
			segment = odeint(globals()[seg_type], [start_val, end_val], np.linspace(0, 1, seg_dur))
		else:
			raise ValueError("Invalid segment type specified.")

		seg_y = segment[:, 1]
		segments.append(seg_y)

	concatenated_y = np.concatenate(segments)

	# Plot concatenated segments
	plt.plot(concatenated_y)
	plt.xlabel('Samples')
	plt.ylabel('Amplitude')
	plt.title('Concatenated Segments')
	plt.grid(True)
	plt.show()

	# Generate WAV file
	sf.write('concatenated_segments.wav', concatenated_y, sample_rate, 'PCM_24')
	print("WAV file 'concatenated_segments.wav' generated successfully.")

# Example usage:
gen_curve((1/16, 1, 'linear'), (14/16, 0.4, 'diocles'), (1/16, 0, 'brachistochrone'))
