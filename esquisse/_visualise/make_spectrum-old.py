import numpy as np
import matplotlib
matplotlib.use('Agg')  # Use a non-GUI backend
import matplotlib.pyplot as plt
import os
from wand.image import Image
from wand.color import Color
from wand.drawing import Drawing
import librosa
import random
import concurrent.futures

from .utils import seconds_to_mmss

def create_channel_image(args):
	audio_file, i, channel, n_fft, hop_length, sr, custom_cmap, width, height, dpi = args

	D = librosa.stft(channel, n_fft=n_fft, hop_length=hop_length)
	S_db = librosa.amplitude_to_db(np.abs(D), ref=np.max)
	duration = len(S_db[0]) * hop_length / sr

	fig, ax = plt.subplots(dpi=dpi, figsize=(width // dpi, height // dpi))  # Adjust the figsize for width and height
	librosa.display.specshow(S_db, x_axis='time', y_axis='log', ax=ax, n_fft=n_fft, hop_length=hop_length, sr=sr, cmap=plt.get_cmap(custom_cmap))
	ax.set_axis_off()

	name = f'channel_{i + 1}'
	export_filename =  f'{audio_file.split(".")[0]}-{name}.png'
	fig.savefig(export_filename, dpi=dpi, bbox_inches='tight', pad_inches=0)
	plt.close(fig)
	
	with Drawing() as draw:
		with Image(filename=export_filename) as image:
			#draw.font = '/System/Library/Fonts/Supplemental/Courier New Bold.ttf'
			#draw.font_size = 35
			#draw.text(int(draw.font_size) // 2, image.height - int(draw.font_size) // 2, name)
			if i == 0:
				num_ticks = 15  # Adjust the number of ticks as needed
				x_ticks = np.linspace(0, image.width, num_ticks, dtype=np.uint16)

				for x in x_ticks:
					draw.line((x, 0), (x, 15))
					tick_label = seconds_to_mmss(int(x / image.width * (duration - 1)))
					draw.font_size = 25
					draw.font = '/System/Library/Fonts/Supplemental/Courier New.ttf'
					if x != 0 and x != image.width:
						draw.text(int(x - (draw.font_size // 2)), int(draw.font_size)+15, tick_label)
					draw(image)
			else:
				draw(image)

			image.save(filename=export_filename)
	
	return export_filename

def make_transparency(input_file):
	with Image(filename=input_file) as img:
		fuzz = 0.15
		img.transparent_color(Color('white'), 0, fuzz=int(np.iinfo(np.uint16).max * fuzz))
		img.save(filename=input_file)

def make_spectrum(audio_file, output_file):
	print(f'Make spectrogram for {audio_file} for {output_file}')
	y, sr = librosa.load(audio_file, sr=None, mono=False)
	channels = y.shape[0]
	n_fft = 4096
	hop_length = n_fft // 8
	width = 4096
	height = width // (channels*2)
	dpi = width / (height / 25.4)
	custom_cmaps = [
		'RdPu',
		'PuRd',
		'BuPu',
		'PuBu',
		]
	custom_cmap = random.choice(custom_cmaps)

	with concurrent.futures.ProcessPoolExecutor(max_workers=channels) as executor:
		args_list = [(audio_file, i, y[i, :], n_fft, hop_length, sr, custom_cmap, width, height, dpi) for i in range(channels)]
		futures = [executor.submit(create_channel_image, args) for args in args_list]

	pics = [future.result() for future in futures]

	with Image() as output:
		for input_file in pics:
			print(input_file)
			with Image(filename=input_file) as img:
				output.sequence.append(img)

		output.concat(True)
		output.save(filename=output_file)

	for p in pics:
		os.remove(p)

