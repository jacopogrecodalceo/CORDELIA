import json
import os
import re
import soundfile as sf

import librosa
import numpy as np
from pathlib import Path
'''
This script make principally the .JSON for the instrument
'''

HARD_RESET = False
HARD_RESET_with_anal = False


class Input_file:
    def __init__(self, path):
        self.path = path
        self.name = Path(path).stem
        self.extension = Path(path).suffix[1:]
        self.dir = Path(path).parent

audio_extensions = ['.flac', '.wav']

default_sonvs_dir = './default/sonvs'
default_sonvs = {}
for file_name in os.listdir(default_sonvs_dir):
	if file_name.endswith('.orc'):
		file_path = os.path.join(default_sonvs_dir, file_name)
		key = file_path.split('/')[-1].split('.')[0]
		default_sonvs[key] = file_path

def extract_global_vars(path, name):
	content = open(path).read()
	gk_vars = list(set(re.findall(r'\bgk' + name + r'\w+', content)))
	gi_vars = list(set(re.findall(r'\bgi' + name + r'\w+', content)))
	return gk_vars + gi_vars

def process_instr(directory, json_file):
	# Processing 'instr' type files
	for root, _, files in os.walk(directory):
		for file in files:
			basename, extension = os.path.splitext(file)
			if extension == '.orc':
				file_path = os.path.join(root, file)

				if basename not in json_file:
					json_file[basename] = {
						'type': 'instr',
						'path': file_path,
						'global_var': extract_global_vars(file_path, basename)
					}
			elif extension == '.py':
				file_path = os.path.join(root, file)

				if basename not in json_file:
					json_file[basename] = {
						'type': 'scripted_instr',
						'path': file_path,
						'extension': extension
					}				

def process_hybrid(directory, json_file):
	# Processing 'hybrid' type files
	for root, _, files in os.walk(directory):
		for file in files:
			basename, extension = os.path.splitext(file)
			if extension == '.orc':
				file_path = os.path.join(root, file)

				if basename not in json_file:
					first_lines = open(file_path).readlines()[:5]
					keyword = ';REQUIRE'
					required_instr = []

					for l in first_lines:
						if l.startswith(keyword):
							line = l.replace(keyword, '').strip()
							required_instr.extend(line.split(','))

					json_file[basename] = {
						'type': 'hybrid',
						'path': file_path,
						'required': required_instr,
						'global_var': extract_global_vars(file_path, basename)
					}

def sonvs_anal(directory):
	json_file = './config/sonvs_anal.json'

	if HARD_RESET_with_anal or not os.path.exists(json_file):
		anals = {}
	else:
		with open(json_file, 'r') as f:
			anals = json.load(f)

	for file in os.listdir(directory):
		file_path = os.path.join(directory, file)
		if os.path.isfile(file_path):
			_, extension = os.path.splitext(file)
			if extension in audio_extensions and file_path not in anals:
				audio, sr = librosa.load(file_path)
				f0 = librosa.yin(audio, fmin=25, fmax=3500)
				main_f0 = np.median(f0)
				anals[file_path] = {'pitch': str(main_f0)}
	with open(json_file, 'w') as f:
		json.dump(anals, f, indent=4)
	return anals
		
def get_audio_channels(file_path):
	with sf.SoundFile(file_path) as f:
		return f.channels

def process_sonvs(directory, json_file):

	anals_json = sonvs_anal(directory)

	for file in os.listdir(directory):
		file_path = os.path.join(directory, file)
		
		if os.path.isfile(file_path):

			for variant in default_sonvs.keys():
				basename, extension = os.path.splitext(file)
				if variant != '_':
					basename += variant		

				if extension in audio_extensions and basename not in json_file:
					print(f'{basename} is added.')



					json_file[basename] = {
						'type': 'sonvs',
						'channels': get_audio_channels(file_path),
						'path': [file_path],
						'pitch': anals_json[file_path]['pitch'],
						'orc': default_sonvs[variant]
					}
		else:

			audio_files = []
			
			for f in os.listdir(file_path):
				_, extension = os.path.splitext(f)
				
				if extension in audio_extensions:
					audio_files.append(os.path.join(file_path, f))

			if audio_files:
				for variant in default_sonvs.keys():
					basename = file
					if variant != '_':
						basename += variant		
					json_file[basename] = {
						'type': 'dir_sonvs',
						'channels': get_audio_channels(audio_files[0]),
						'path': audio_files,
						'pitch': "440",
						'orc': default_sonvs[variant]
					}


def make(directory, json_file):
	# Load existing instruments data from JSON file or initialize an empty dictionary
	if HARD_RESET or not os.path.exists(json_file):
		instr_json = {}
	else:
		with open(json_file, 'r') as f:
			instr_json = json.load(f)

	# Process different types of files
	for dirname in os.listdir(directory):
		if dirname == 'instr':
			local_directory = os.path.join(directory, dirname)
			process_instr(local_directory, instr_json)

		elif dirname == 'hybrid':
			local_directory = os.path.join(directory, dirname)
			process_hybrid(local_directory, instr_json)

		elif dirname == 'sonvs':
			local_directory = os.path.join(directory, dirname)
			process_sonvs(local_directory, instr_json)

	# Sort instruments dictionary and write to JSON file
	instr_json = dict(sorted(instr_json.items()))
	with open(json_file, 'w') as f:
		json.dump(instr_json, f, indent=4)

