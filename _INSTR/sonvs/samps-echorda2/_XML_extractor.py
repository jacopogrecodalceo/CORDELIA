import xml.etree.ElementTree as ET
import json

midi_json_path = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_releted/midi_name_freq.json'


with open(midi_json_path, 'r') as file:
    midi_data = json.load(file)

def extract_if_statements(xml_string):
	root = ET.fromstring(xml_string)
	if_statements = []

	note_names_extracted = []
	for i, sample in enumerate(root.findall('.//sample')):
		path_note = sample.get('path')
  
		extract_note = path_note.split('_')[-1].split('.')[0]
		midi_note = midi_data['note_name'].index(extract_note)
		note_names_extracted.append((extract_note, midi_note))
  
	sorted_note_nums_extracted = sorted(note_names_extracted, key=lambda x: x[1])

	for i in range(len(sorted_note_nums_extracted)-1):
		note_name, note_num = sorted_note_nums_extracted[i]
		next_note_name, next_note_num = sorted_note_nums_extracted[i + 1]
		if i == 0:
			lo_note = 0
			hi_note = next_note_num-1
			root_note = note_num
			if_statement = f'''if inote <= {hi_note} && inote > {lo_note} then
	irootnote = {root_note}
	Snote_name init "{note_name}"'''
			if_statements.append(if_statement)

		elif i < len(sorted_note_nums_extracted)-2:
			lo_note = note_num-1
			hi_note = next_note_num-1
			root_note = note_num	
			if_statement = f'''elseif inote <= {hi_note} && inote > {lo_note} then
	irootnote = {root_note}
	Snote_name init "{note_name}"'''	

			if_statements.append(if_statement)
		elif i == len(sorted_note_nums_extracted)-2:
			lo_note = note_num-1
			hi_note = 127
			root_note = next_note_num
			if_statement = f'''elseif inote <= {hi_note} && inote > {lo_note} then
	irootnote = {root_note}
	Snote_name init "{next_note_name}"'''	

			if_statements.append(if_statement)
	if_statements.append('endif')
	
	return if_statements

path = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-echorda2/_ECHORDA_2.dspreset'

with open(path, 'r') as f:
	xml_data = f.read()
ifs_list = extract_if_statements(xml_data)
for if_list in ifs_list:
    print(if_list)