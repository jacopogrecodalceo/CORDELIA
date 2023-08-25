import re
from constants.var import cordelia_json

attribute_order = ['name', 'rhythm', 'space', 'dur', 'dyn', 'freq', 'core', 'routing', 'csound_code']


class Instrument:
	def __init__(self, name):
		self.name = name

	def __eq__(self, other):
		self.name == other.name and self.routing == other.routing

	def __ne__(self, other):
		self.name != other.name and self.routing != other.routing

	def print_attributes(self):
		attribute_names = dir(self)
		for name in attribute_names:
			if not name.startswith('__') and not callable(getattr(self, name)):
				print(f"{name}: {getattr(self, name)}")
	
	def get_attributes(self):
		post_instruments = []
		for name in attribute_order:
			if hasattr(self, name):
				post_instruments.append(getattr(self, name))
		return post_instruments
	
	def converter(self):
		if not hasattr(self, 'csound_code'):
			for attr_name in dir(self):
				if attr_name.startswith('convert_'):
					func = getattr(self, attr_name)
					func()

	def convert_space(self):
		space = self.space[0] if isinstance(self.space, list) else self.space
		if space != 0:
			replacements = {
							'r': 'girot',
							'l': 'giline',
							'e': 'gieven',
							'o': 'giodd',
							'a': 'giarith',
							'd': 'gidist',
							}

			for prefix, replacement in replacements.items():
				if re.search(f'^[-]?{prefix}\d+', space):
					prestring = space.replace(f'{prefix}', f'{replacement}')
					space = f'oncegen({prestring})'

	def convert_route(self):
		routing_json = cordelia_json['ROUTING']

		# Exemple:
		# self.routing = [
		# 	{'name': 'moij', 'params': ['ntof(3)', '.95']},
		# 	{'name': 'tapij', 'params': ['3']},
		# 	{'name': 'convij', 'params': ['aaron', '2']}
		# ]

		#INIT
		lines = ['''
if p4 == 0 then

	indx        init 1
	until   indx > ginchnls do
		schedule p1 + indx/1000, 0, -1, indx
		indx    += 1
	od

	turnoff

else

	ich init p4
	xtratim gixtratim

	krel 		init 0
	krel        release
	igain       init 1
	kgain_in    cosseg 0, .015, 1
	kgain_out   init 1

	if krel == 1 then
		kgain_in cosseg igain, gixtratim/4, igain/2, gixtratim*3/4, 0 
		kgain_out cosseg igain, gixtratim/2, igain, gixtratim/2, 0
	endif
	''']

		lines.extend([
			f'\tamain_in chnget sprintf("%s_%i", "{self.name}", ich)',
			'\tamain_in *= kgain_in'
		])

		# Add name to instrument
		#route_var = f'gS{route_dict["name"]}{route_index}_{name}{self.index}_p1'
		#route_dict['params'].insert(0, (route_var, f'"{name}"')) 
		#    
		
		params_updated = []
		for rounting_index, routing in enumerate(self.routing, start = 1):
			routing_vars = []
			name = routing['name']
			xin = routing_json[name]['xin']
			for i, var_type in enumerate(xin):
				routing_var = f'g{var_type}{name}{rounting_index}_{self.name}{self.index}_p{i + 1}'
				param_value = routing['params'][i] if i < len(routing['params']) else None
				routing_vars.append(routing_var)
				if param_value:
					params_updated.append(f'{routing_var} = {param_value}')
			
			string = routing_json[name]['core']
			for i in range(len(xin)):
				route_var = routing_vars[i]
				string = re.sub(rf'(\W|^)PARAM_{i + 1}(\W|$)', rf'\1{route_var}\2', string)

			input_var = 'amain_in' if rounting_index == 1 else f'aparent_out{rounting_index - 1}'
			output_var = 'amain_out' if rounting_index == len(self.routing) else f'aparent_out{rounting_index}'

			string = re.sub(r'(\W|^)PARAM_IN(\W|$)', rf'\1{input_var}\2', string)
			string = re.sub(r'(\W|^)PARAM_OUT(\W|$)', rf'\1{output_var}\2', string)

			lines.append(string)

		lines.extend([
			'\tchnmix amain_out*kgain_out, gSmouth[ich-1]',
			'endif'
		])

		self.routing = params_updated
		self.routing.append('\n'.join(lines))

	def make_variables(self):
		if not hasattr(self, 'csound_code'):
			rhythm_var = f'gkrhy_{self.index}'
			self.rhythm = f'{rhythm_var} {self.rhythm["name"]} {", ".join(self.rhythm["params"] if isinstance(self.rhythm["params"], list) else [self.rhythm["params"]])}'

			if_openvar = f'\tif {rhythm_var} != 0 then\n'
			if_closevar = f'\n\tendif'

			space_var = f'gkspace_{self.index}'
			space = self.space[0] if isinstance(self.space, list) else self.space
			if space != '':
				self.space = f'{if_openvar}{space_var} = {space}{if_closevar}'
			else:
				self.space = f'{space_var} = 0'
				
			name_var = f'gSname_{self.index}'
			self.name = f'{name_var} = "{self.name}"'

			dur_var = f'gkdur_{self.index}'
			dur = self.dur[0] if isinstance(self.dur, list) else self.dur
			self.dur = f'{dur_var} = {dur}'

			dyn_var = f'gkdyn_{self.index}'
			dyn = self.dyn[0] if isinstance(self.dyn, list) else self.dyn
			self.dyn = f'{dyn_var} = {dyn}*({rhythm_var} == 1 ? ampdb(5) : 1)'

			env_var = f'gkenv_{self.index}'
			env = self.env[0] if isinstance(self.env, list) else self.env
			self.env = f'{env_var} = {env}'

			freq_updated = []
			freq_vars = []
			for i, freq in enumerate(self.freq):
				#print(self.freq[i])
				freq_var = f'gkfreq_{self.index}_{i + 1}'
				freq_vars.append(freq_var)
				freq_updated.append(f'{freq_var} = {freq}')
			
			self.freq = freq_updated
			
			freq_string = ", \n".join(freq_vars)

			self.core = f'''
if {rhythm_var} != 0 then
	eva({space_var}, {name_var},
	{dur_var},
	{dyn_var},
	{env_var},
	{freq_string})
	endif
'''

class postInstrument:
	def __init__(self, index, instr):
		self.index = index
		self.instr = instr

	def log(self):
		print(self.index)
		print(self.instr)