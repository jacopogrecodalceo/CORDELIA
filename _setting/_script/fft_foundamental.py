import numpy as np
import librosa
import json

CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIA'
JSON_PATH = CORDELIA_DIR + '/_setting' + '/instr.json'

prefix = ['_samp', '_sync']

with open(JSON_PATH, 'r') as f:
	INSTR_JSON = json.load(f)

keys_to_update = []  # List to store keys that need to be updated

for each in INSTR_JSON:
	if len(INSTR_JSON[each]['path']) == 1 and 'pitch' not in INSTR_JSON[each]:
		if f'{each}_samp' not in INSTR_JSON:
			keys_to_update.append(each)

for each in keys_to_update:
	path = INSTR_JSON[each]['path']
	INSTR_JSON[f'{each}_samp'] = INSTR_JSON[each].copy()
	INSTR_JSON[f'{each}_sync'] = INSTR_JSON[each].copy()

	print(f'I am treating: {each}')
	# Load the audio file
	audio, sr = librosa.load(path[0])

	# Extract the fundamental frequency
	f0 = librosa.yin(audio, fmin=50, fmax=1500)

	# Find the main fundamental frequency using statistical mode
	main_f0 = np.median(f0)

	# Update the fundamental frequency in the copied dictionary
	INSTR_JSON[f'{each}_samp']['pitch'] = main_f0
	INSTR_JSON[f'{each}_sync']['pitch'] = main_f0

with open(JSON_PATH, 'w') as file:
	json.dump(INSTR_JSON, file, indent=4, sort_keys=True)
