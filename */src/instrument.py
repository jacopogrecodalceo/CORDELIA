import re
from constants.var import cordelia_json

attribute_order = ['name', 'rhythm', 'space', 'dur', 'dyn', 'env', 'freq', 'core', 'routing', 'code']

instr_last = []

def insert_each(rhythm_var, var):
	if len(var) == 1:
		res = var[0]
	elif len(var) == 2:
		res = f'{rhythm_var} == 1 ? {var[0]} : {var[1]}'
	elif len(var) == 3:
		res = f'{rhythm_var} == {var[2]} ? {var[0]} : {var[1]}'
	else:
		res = var
	return res

class Instrument:

	def print_attributes(self):
		attribute_names = dir(self)
		for name in attribute_names:
			if not name.startswith('__') and not callable(getattr(self, name)):
				print(f"{name}: {getattr(self, name)}")
		print('.'*65)
	
	def get_attributes(self):
		instruments = []
		for name in attribute_order:
			if hasattr(self, name):
				instruments.append(getattr(self, name))
		return instruments
	
	def spell(self):
		if self.name != 'cordelia':
			for attr_name in dir(self):
				if attr_name.startswith('spell_'):
					func = getattr(self, attr_name)
					func()

	def spell_space(self):
		if hasattr(self, 'space'):
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
						self.space = f'oncegen({prestring})'

	def spell_route(self):
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
		kgain_in cosseg igain, gixtratim/4, 0, gixtratim*3/4, 0 
		kgain_out cosseg igain, gixtratim*2/3, igain, gixtratim/3, 0
	endif
''']

		lines.extend([
			f'\tamain_in chnget sprintf("%s_%i", "{self.name}", ich)',
			'\tamain_in *= kgain_in'
		])
		# Add name to instrument
		#route_var = f'gS{route_dict["name"]}{route_name_id}_{name}{self.name_id}_p1'
		#route_dict['params'].insert(0, (route_var, f'"{name}"')) 
		#    
		if not self.routing:
				self.routing.append({'name': 'getmeout'})
		params_updated = []
		for rounting_name_id, routing in enumerate(self.routing, start = 1):
			routing_vars = []
			name = routing['name']
			xin = routing_json[name]['input']
			for i, var_type in enumerate(xin):
				routing_var = f'g{var_type}{name}{rounting_name_id}_{self.name}{self.name_id}_p{i + 1}'
				if 'params' in routing:
					param_value = routing['params'][i] if i < len(routing['params']) else None
				else:
					param_value = None
				routing_vars.append(routing_var)
				if param_value:
					param_value = f'"{param_value}"' if var_type == 'S' else param_value
					params_updated.append(f'{routing_var} = {param_value}')
			
			string = routing_json[name]['core']
			for i in range(len(xin)):
				route_var = routing_vars[i]
				string = re.sub(rf'(\W|^)PARAM_{i + 1}(\W|$)', rf'\1{route_var}\2', string)

			input_var = 'amain_in' if rounting_name_id == 1 else f'aparent_out{rounting_name_id - 1}'
			output_var = 'amain_out' if rounting_name_id == len(self.routing) else f'aparent_out{rounting_name_id}'

			string = re.sub(r'(\W|^)PARAM_IN(\W|$)', rf'\1{input_var}\2', string)
			string = re.sub(r'(\W|^)PARAM_OUT(\W|$)', rf'\1{output_var}\2', string)
			
			lines.append('\n;---\n')
			lines.append(string)
			lines.append('\n;---\n')

		lines.extend([
			'\tchnmix amain_out*kgain_out, gSmouth[ich-1]',
			'endif'
		])

		self.routing = params_updated
		self.routing.append('\n'.join(lines))

	def make_variables(self):
		if self.name != 'cordelia':

			instrument_name = self.name

			if hasattr(self, 'rhythm'):
				rhythm_var = f'gkrhythm_{instrument_name}{self.name_id}'
				self.rhythm = f'{rhythm_var} {self.rhythm["name"]} {", ".join(self.rhythm["params"] if isinstance(self.rhythm["params"], list) else [self.rhythm["params"]])}'

				if_openvar = f'\tif {rhythm_var} != 0 then\n'
				if_closevar = f'\n\tendif'

			if hasattr(self, 'space'):
				space_var = f'gkspace_{instrument_name}{self.name_id}'
				space = self.space[0] if isinstance(self.space, list) else self.space
				if space != '':
					self.space = f'{if_openvar}{space_var} = {space}{if_closevar}'
				else:
					self.space = f'{space_var} = 0'
				
			name_var = f'gSname_{instrument_name}{self.name_id}'
			self.name = f'{name_var} = "{self.name}"'

			if hasattr(self, 'dur'):
				dur_var = f'gkdur_{instrument_name}{self.name_id}'
				dur = insert_each(rhythm_var, self.dur)
				self.dur = f'{dur_var} = {dur}'

			if hasattr(self, 'dyn'):
				dyn_var = f'gkdyn_{instrument_name}{self.name_id}'
				dyn = insert_each(rhythm_var, self.dyn)
				#self.dyn = f'{dyn_var} = {dyn}*({rhythm_var} == 1 ? ampdb(5) : 1)'
				self.dyn = f'{dyn_var} = {dyn}'

			if hasattr(self, 'env'):
				env_var = f'gkenv_{instrument_name}{self.name_id}'
				env = self.env[0] if isinstance(self.env, list) else self.env
				self.env = f'{env_var} = {env}'

			if hasattr(self, 'freq'):
				freq_updated = []
				freq_vars = []
				for i, freq in enumerate(self.freq):
					#print(self.freq[i])
					freq_var = f'gkfreq{i + 1}_{instrument_name}{self.name_id}'
					freq_vars.append(freq_var)
					freq_updated.append(f'{freq_var} = {freq}')
			
				self.freq = freq_updated
			
			if hasattr(self, 'core'):
				self.core = f'''
if {rhythm_var} != 0 then
	eva({space_var}, {name_var},
	{dur_var},
	{dyn_var},
	{env_var},
	{", ".join(freq_vars)})
endif\n'''
