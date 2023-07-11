import re

import src.utils as utils
import config.const_path as const_path

class Parsing:

	def __init__(self, instrument_name, node):

		self.instrument_name = instrument_name

		if instrument_name == 'cordelia':
			self.csound_code = node.csound_code
		else:
			self.rhythm_name = node.rhythm_name
			self.rhythm_params = node.rhythm_params
			
			self.space = self.parse_space(node.space)
			self.dur = node.dur
			self.env = node.env
			self.freqs = self.parse_freq(node.freqs)

			self.dyn = self.parse_dyn(node.dyn, node.freqs)

			self.routes = self.parse_route(node.routes)

	def parse_space(self, string):

		replacements = {
			'r': 'girot',
			'l': 'giline',
			'e': 'gieven',
			'o': 'giodd',
			'a': 'giarith',
			'd': 'gidist',
		}

		for prefix, replacement in replacements.items():
			if re.search(f'^[-]?{prefix}\d+', string):
				prestring = string.replace(f'{prefix}', f'{replacement}')
				string = f'oncegen({prestring})'

		return string

	def parse_dyn(self, string, list):

		db_values = {
			2: '-5',
			3: '-7',
			4: '-9',
			5: '-11'
		}

		string += '*ampdb(' + db_values.get(len(list), '') + ')'

		return string

	def parse_freq(self, freq_lines):

		res = []

		for freq_line in freq_lines:
			is_first_note = re.search(r'^(".*")', freq_line)
			if is_first_note:
				is_cpstun = re.search(r'^(".*"):', freq_line)
				if is_cpstun:
					intervals = freq_line.split(':')[1].lstrip()
					freq_line = f'cpstun_render(ntom({is_cpstun[1]})+once({intervals}), gktuning)'
					res.append(freq_line)
				else:
					note = re.search(r'^(".*")', freq_line)[1]
					cycle, limit, tab = re.findall(r'^"\w+"-(\d+)\.(\d+):(.*?)$', freq_line)[0]
					freq_line = f'cpstun_render(ntom({note})+int(tablekt:k((chnget:k("heart") * {cycle}) % 1, {tab}, 1)*{limit}), gktuning)'
					res.append(freq_line)
			else:
				res.append(freq_line)

		return res


	def parse_route(self, routes):
		# e.g. routes = ['getmeout(1)', moij(asd, asd)]
		# --> [{'name': 'getmeout', 'params': ['1']}, {'name': 'moij', 'params': ['asd', 'asd']}]
		# --> [{'name': 'getmeout', 'params': [{'gkgetmeout_p1': '1'}]}, {'name': 'moij', 'params': ['asd', 'asd']}]

		routes_dict = [
			{'name': match.group(1), 'params': utils.extract_comma_params(match.group(2))}
			if match else {'name': route}
			for route in routes
			if (match := re.match(r'^(\w+)\((.*?)\)$', route))
		]

		return routes_dict
	

class GlobalVariable():
		
	def __init__(self, index, Parsing):

		if Parsing.instrument_name == 'cordelia':
		
			self.__dict__.update(vars(Parsing))
			self.index = index
			#self.index = index
			del self.instrument_name
		
		else:
			
			rhythm_var = f'gkrhy_{index}'
			self.rhythm = f'{rhythm_var} {Parsing.rhythm_name} {", ".join(Parsing.rhythm_params)}'

			if_openvar = f'\tif {rhythm_var} != 0 then\n'
			if_closevar = f'\n\tendif'

			space_var = f'gkspace_{index}'
			self.space = f'{if_openvar}{space_var} = {Parsing.space}{if_closevar}'

			name_var = f'gSname_{index}'
			self.instrument_name = f'{name_var} = "{Parsing.instrument_name}"'

			dur_var = f'gkdur_{index}'
			self.dur = f'{dur_var} = {Parsing.dur}'

			dyn_var = f'gkdyn_{index}'
			self.dyn = f'{dyn_var} = {Parsing.dyn}*({rhythm_var} == 1 ? ampdb(5) : 1)'

			env_var = f'gkenv_{index}'
			self.env = f'{env_var} = {Parsing.env}'

			self.freqs = []
			freq_vars = []
			for i in range(5):
				if i <= (len(Parsing.freqs)-1):
					#print(Parsing.freq[i])
					freq_var = f'gkfreq_{index}_{i+1}'
					freq_vars.append(freq_var)
					freq = f'{freq_var} = {Parsing.freqs[i]}'
					self.freqs.append(freq)
			
			freq_string = ", \n".join(freq_vars)

			self.index = index

			self.route = self.parse_route(Parsing.instrument_name, Parsing.routes)

			self.core_instrument = f'''
if {rhythm_var} != 0 then
eva({space_var}, {name_var},
{dur_var},
{dyn_var},
{env_var},
{freq_string})
endif'''


	def parse_route(self, instrument_name, routes_dict):
			
		lines = []
		
		#INIT
		lines.append('''
if p4 == 0 then

	indx		init 1
	until	indx > ginchnls do
		schedule p1 + indx/1000, 0, -1, indx
		indx	+= 1
	od

	turnoff

else

	ich init p4
	xtratim gixtratim

	krel		init 0
	krel		release
	igain		init 1
	kgain_in	cosseg 0, .015, 1
	kgain_out	init 1

	if krel == 1 then
		kgain_in cosseg igain, gixtratim/4, igain/2, gixtratim*3/4, 0 
		kgain_out cosseg igain, gixtratim/2, igain, gixtratim/2, 0
	endif

	''')

		lines.extend([
			f'\tamain_in chnget sprintf("%s_%i", "{instrument_name}", ich)',
			'\tamain_in *= kgain_in'
		])

		# Add name to instrument
		#route_var = f'gS{route_dict["name"]}{route_index}_{instrument_name}{self.index}_p1'
		#route_dict['params'].insert(0, (route_var, f'"{instrument_name}"'))	

		#CORE
		for route_index, route_dict in enumerate(routes_dict, start=1):

			for index_var, value in enumerate(route_dict['params']):
				route_var = f'gk{route_dict["name"]}{route_index}_{instrument_name}{self.index}_p{index_var+1}'
				route_dict['params'][index_var] = [route_var, value]

			if route_dict['name'] in const_path.MODULE_json:
				#csound_cordelia.compileOrcAsync(f.read())
				string = const_path.MODULE_json[route_dict['name']]['core']
				for i in range(const_path.MODULE_json[route_dict['name']]['how_many_p']):
					try:
						string = re.sub(rf'(\W|^)PARAM_{i+1}(\W|$)', rf'\1{route_dict["params"][i][0]}\2', string)
					except IndexError:
						local_var = f'k{route_dict["name"]}{route_index}_p{i+1}'
						string = re.sub(rf'(\W|^)PARAM_{i+1}(\W|$)', rf'\1{local_var}\2', string)

				input_var = 'amain_in' if route_index == 1 else f'aparent_out{route_index-1}'
				output_var = 'amain_out' if route_index == len(routes_dict) else f'aparent_out{route_index}'

				string = re.sub(rf'(\W|^)PARAM_IN(\W|$)', rf'\1{input_var}\2', string)
				string = re.sub(rf'(\W|^)PARAM_OUT(\W|$)', rf'\1{output_var}\2', string)

				lines.append(string)

		lines.extend([
			'\tchnmix amain_out*kgain_out, gSmouth[ich-1]',
			'\tendif'
		])

		return '\n'.join(lines)


def wrapper(instruments):
	
	instrument_start = 500

	result = []
	index = 0
	for instrument in instruments:
		content = []
		for attr, v in vars(instrument).items():
			if attr != 'index':
				if attr == 'freqs':
					content.extend(v)
				else:
					content.append(v)	

		for e in content:
			instrument_num = instrument_start + index
			string = f'\tinstr {instrument_num}\n'
			string += e + '\n'
			string += '\tendin\n'
			string += f'turnoff2_i {instrument_num}, 0, 1\n'
			string += f'schedule {instrument_num}, ksmps / sr, -1\n'
			
			result.append(string)
			print(string)
			index += 1

	return result