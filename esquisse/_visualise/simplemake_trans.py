import concurrent.futures
from wand.image import Image, Color
import os 
import numpy as np

directory = '/Users/j/Desktop/pics'
file_paths = [os.path.join(directory, filename) for filename in os.listdir(directory) if os.path.isfile(os.path.join(directory, filename))]

def make_transparency(input_file):
	with Image(filename=input_file) as img:
		fuzz = 0.15
		img.transparent_color(Color('white'), 0, fuzz=int(np.iinfo(np.uint16).max * fuzz))
		img.save(filename=input_file)

# Process channels in parallel
with concurrent.futures.ThreadPoolExecutor() as executor:
	list(executor.map(make_transparency, file_paths))
