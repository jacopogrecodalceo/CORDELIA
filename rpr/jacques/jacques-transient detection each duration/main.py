#!/usr/bin/env python3
import argparse
import librosa
import librosa.display
import numpy as np
import matplotlib.pyplot as plt
import os


def compute_energy(y, hop_length=512):
	"""Compute frame-wise energy."""
	return np.array([
		np.sum(frame ** 2)
		for frame in librosa.util.frame(y, frame_length=hop_length, hop_length=hop_length)
	])


def filter_cyclic(transients, each_dur, window_size):
   if len(transients) == 0:
      return np.array([])

   selected = []
   pos = each_dur
   max_time = transients[-1]

   while pos <= max_time + each_dur:
      window_start = pos - window_size
      window_end = pos + window_size

      candidates = transients[
         (transients >= window_start) & (transients <= window_end)
      ]

      if len(candidates) > 0:
         nearest = candidates[np.argmin(np.abs(candidates - pos))]
         selected.append(nearest)
         pos = nearest + each_dur   # shift phase
      else:
         pos += each_dur            # fallback → avoid freeze

   return np.array(selected)


def parse_args():
	parser = argparse.ArgumentParser()
	parser.add_argument("--input", type=str, required=True)
	parser.add_argument("--output", type=str, required=True)
	parser.add_argument("--source_offset", type=float, required=True)
	parser.add_argument("--item_dur", type=float, required=True)
	parser.add_argument("--each_dur", type=int, required=True)
	parser.add_argument("--window_size", type=int, required=True)
	parser.add_argument("--leading_pad", type=int, required=True)
	parser.add_argument("--onset_delta", type=float, default=.5)

	return parser.parse_args()


def main():
	args = parse_args()

	y, sr = librosa.load(
		args.input,
		sr=None,
		mono=True,
		offset=args.source_offset,
		duration=args.item_dur,
	)

	each_dur = args.each_dur / 1000
	window_size = args.window_size / 1000
	leading_pad = args.leading_pad / 1000

	# Detect peaks
	hop_length = 512
	onset_env = librosa.onset.onset_strength(y=y, sr=sr, hop_length=hop_length)
	all_transients = librosa.onset.onset_detect(y=y, sr=sr, units='time')

	# Compensate for hop_length latency
	frame_offset = hop_length / sr
	all_transients = all_transients - frame_offset - leading_pad

	# Filter by cycles
	selected = filter_cyclic(all_transients, each_dur, window_size)

	# Write output
	with open(args.output, "w") as f:
		for t in selected:
			f.write(f"{t}\n")

	print(f"Selected {len(selected)} transients")

	# Plot only selected
	if len(selected) > 0:
		fig, ax = plt.subplots(nrows=3, sharex=True, figsize=(16, 10))

		# Spectrogram
		D = np.abs(librosa.stft(y, hop_length=hop_length))
		librosa.display.specshow(
			librosa.amplitude_to_db(D, ref=np.max),
			y_axis='log',
			x_axis='time',
			sr=sr,
			hop_length=hop_length,
			ax=ax[2]
		)
		ax[2].set_title('Spectrogram')

		# Onset
		times = librosa.frames_to_time(np.arange(len(onset_env)), sr=sr, hop_length=hop_length)
		ax[1].plot(times, onset_env, alpha=0.8)
		ax[1].vlines(selected, 0, onset_env.max(), color='g', linewidth=2, label=f'Selected ({len(selected)})')
		ax[1].set_ylabel('Onset Strength')
		ax[1].set_title('Onset Detection')
		ax[1].legend()

		# Waveform
		t = np.arange(len(y)) / sr
		ax[0].plot(t, y, alpha=0.6, linewidth=0.5)
		ax[0].vlines(selected, y.min(), y.max(), color='g', linewidth=1.5)
		ax[0].set_ylabel('Amplitude')
		ax[0].set_title('Waveform')

		plt.tight_layout()
		output_dir = os.path.dirname(args.output)
		plot_path = os.path.join(output_dir, os.path.splitext(os.path.basename(args.output))[0] + '-plot.png')
		plt.savefig(plot_path, dpi=150, bbox_inches='tight')
		print(f"Plot saved to {plot_path}")
		plt.close()


if __name__ == "__main__":
	main()