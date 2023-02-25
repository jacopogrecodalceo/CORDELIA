import json
import re

with open('/Users/j/Documents/PROJECTs/CORDELIAv4/_setting' + '/instr.json') as f:
	CORDELIA_INSTR_json = json.load(f)


defalut_sonvs_path = '/Users/j/Documents/PROJECTs/CORDELIAv4/_setting/_default-sonvs'

name = 'arm1'
type = CORDELIA_INSTR_json[name]['type']
if type == 'sonvs':

	channels = CORDELIA_INSTR_json[name]['channels']
	path = CORDELIA_INSTR_json[name]['path']

	with open(defalut_sonvs_path) as f:

		string = f'gS{name}_file init "{path}"' + '\n'
		string += f'gi{name}_ch init {channels}' + '\n'

		for i in range(int(channels)):
			ch = str(i + 1)
			string += f'gi{name}_{ch} ftgen 0, 0, 0, 1, gS{name}_file, 0, 0, {ch}' + '\n'
			
		string += re.sub(r'---NAME---', name, f.read(), flags=re.MULTILINE)
		print(string)