import os
import json

midi_json_path = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_releted/midi_name_freq.json'


with open(midi_json_path, 'r') as file:
    midi_data = json.load(file)

script_path = os.path.dirname(os.path.abspath(__file__))


wav_files = [f for f in os.listdir(script_path) if f.endswith('.wav')]

if_statements = []

note_nums_extracted = []
for f in wav_files:
	if 'Release' not in f:
		#mRhodes_V3_f_A#3
		note_name = f.split('.')[0]
		find_note_name = note_name[1:] + note_name[:1]
		if 'Release' not in note_name:
			find_note_name = find_note_name.replace('D#', 'Eb').replace('A#', 'Bb').replace('G#', 'Ab')
			midi_num = midi_data['note_name'].index(find_note_name)
			note_nums_extracted.append((note_name, int(midi_num)))

sorted_note_nums_extracted = sorted(note_nums_extracted, key=lambda x: x[1])

EQUALs = []

def find_multiples_of_12_with_remainder(n):
    remainder = n % 12
    return [i for i in range(0, 127 + 1) if i % 12 == remainder]

def make(i, note_name, note_num):
	root_note = note_num
	equal_note = 0
	if_statement = ['if '] if i == 0 else ['elseif']

	for j in range(0, 127 + 1):
		if j % 12 == note_num % 12:
			if_statement.append(f' inote == {j} ||')
			EQUALs.append(j)

	if_statement[-1] = if_statement[-1].replace('||', 'then')

	if_statement.extend([
		f'\n\tirootnote = {root_note}',
		f'\n\tSnote_name init "{note_name}"'
	])
	return ''.join(if_statement)

for i in range(len(sorted_note_nums_extracted)):
	note_name, note_num = sorted_note_nums_extracted[i]
	if i == 0:
		if_statements.append(make(i, note_name, note_num))

	else:
		if_statements.append(make(i, note_name, note_num))

if_statements.append('endif')

for i in range(127):
    if i not in EQUALs:
        raise ValueError(f'MISSING A VALUE: {i}')

for line in if_statements:
    print(line)
 
