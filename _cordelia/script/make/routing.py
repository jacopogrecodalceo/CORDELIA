import json
import os
import re

def extract_text(text, section):
	start = fr';START {section}\s'
	end = fr';END {section}\s'
	match = re.search(f'{start}(.*?){end}', text, re.DOTALL)
	if match:
		return match.group(1).strip()

def make(orc_file, directory, json_file):

	#with open(orc_file, 'w') as mod:
	modules = {}
	for f in os.listdir(directory):
		if f.endswith('.orc'):
			name = f.split('.')[0]

			with open(os.path.join(directory, f), 'r') as file:
				text = file.read()
				text += '\n'

				input_section = extract_text(text, 'INPUT')
				opcode_section = extract_text(text, 'OPCODE')
				core_section = extract_text(text, 'CORE')

				modules[name] = {
					'input': input_section,
					'core': core_section,
					'opcode': opcode_section
					#'path': os.path.join(directory, f)	
				}

				""" if opcode_section:
					string = [
						'\n',
						(';' + '='*35),
						';' + name,
						(';' + '='*35),
						'\n']						
					mod.write('\n'.join(string))
					mod.write(opcode_section)
					mod.write('\n') """

	modules = dict(sorted(modules.items()))
	with open(json_file, 'w') as f:
		json.dump(modules, f, indent=4)
