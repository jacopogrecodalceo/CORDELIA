import xml.etree.ElementTree as ET

def extract_if_statements(xml_string):
	root = ET.fromstring(xml_string)
	if_statements = []

	for i, sample in enumerate(root.findall('.//sample')):
		lo_note = sample.get('loNote')
		hi_note = sample.get('hiNote')
		root_note = sample.get('rootNote')
		path_note = sample.get('path')
  
		extract_note = path_note.split()[3].split('.')[0]
		path_note = path_note.replace(' ', '_').replace('Samples/', '')
		
  
		if lo_note and hi_note and root_note:
			if i == 0:
				if_statement = f'''if inote <= {hi_note} && inote > {lo_note} then
	irootnote = {root_note}
	Snote_name init "{extract_note}"'''
			else:
				if_statement = f'''elseif inote <= {hi_note} && inote > {lo_note} then
	irootnote = {root_note}
	Snote_name init "{extract_note}"'''

  
			if hi_note in if_statements:
				break
       
			if_statements.append(if_statement)

	if_statements.append('endif')

	return if_statements

path = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-kawai_felt/_Kawai Felt Piano.dspreset'

with open(path, 'r') as f:
	xml_data = f.read()
ifs_list = extract_if_statements(xml_data)
for if_list in ifs_list:
    print(if_list)