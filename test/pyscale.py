import json

CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIAv4'

with open(f'{CORDELIA_DIR}/_rpr/midi_name_freq.json') as f:
	MIDI_FREQ = json.load(f)

import numpy as np

def find_index_of_nearest(array, value):
    array = np.asarray(array)
    index = (np.abs(array - value)).argmin()

    return index

nearest_index = find_nearest(MIDI_FREQ['freq'], 300)

print(MIDI_FREQ['freq'][nearest_index])
print(MIDI_FREQ['note_name'][nearest_index])