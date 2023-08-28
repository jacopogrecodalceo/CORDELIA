import json
import os
import re
import sox
import librosa
import numpy as np

HARD_RESET = False
suffix = ['_so', '_sy', '_lpc', '_conv']
audio_extensions = ['.flac', '.wav']

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

def process_sonvs(directory, json_file):

	for file in os.listdir(directory):
		file_path = os.path.join(directory, file)
		
		if os.path.isfile(file_path):
			basename, extension = os.path.splitext(file)
			
			if extension in audio_extensions and basename not in json_file:
				print(f'{basename} is added.')
				
				audio, sr = librosa.load(file_path, sr=None)
				# Extract the fundamental frequency
				f0 = librosa.yin(audio, fmin=25, fmax=3500)
				# Find the main fundamental frequency using statistical mode
				main_f0 = np.median(f0)

				json_file[basename] = {
					'type': 'sonvs',
					'channels': sox.file_info.channels(file_path),
					'path': [file_path],
					'pitch': main_f0
				}
		else:
			audio_files = []
			
			for f in os.listdir(file_path):
				_, extension = os.path.splitext(f)
				
				if extension in audio_extensions:
					audio_files.append(os.path.join(file_path, f))
						
			json_file[file] = {
				'type': 'sonvs',
				'path': audio_files,
				'channels': sox.file_info.channels(audio_files[0])
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

