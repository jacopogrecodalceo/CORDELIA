import numpy as np
import librosa
import json

CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIA'
JSON_PATH = CORDELIA_DIR + '/_setting' + '/instr.json'

with open(JSON_PATH, 'r') as f:
	INSTR_JSON = json.load(f)

path_to_update = set()  # List to store keys that need to be updated

for instr in INSTR_JSON:
	if len(INSTR_JSON[instr]['path']) == 1 and INSTR_JSON[instr]['type'] == 'sonvs' and 'pitch' not in INSTR_JSON[instr]:
		path_to_update.add(INSTR_JSON[instr]['path'][0])

freq_path = {}

for path in path_to_update:
	print(f'I am treating: {path}')
	# Load the audio file
	audio, sr = librosa.load(path)

	# Extract the fundamental frequency
	f0 = librosa.yin(audio, fmin=25, fmax=3500)

	# Find the main fundamental frequency using statistical mode
	main_f0 = np.median(f0)

	freq_path[path] = main_f0

for instr in INSTR_JSON:
	path = INSTR_JSON[instr]['path'][0]
	if path in freq_path:
		INSTR_JSON[instr]['pitch'] = freq_path[path]

with open(JSON_PATH, 'w') as file:
	json.dump(INSTR_JSON, file, indent=4, sort_keys=True)
