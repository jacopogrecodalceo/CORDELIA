import re, json
import pprint

with open('/Users/j/Documents/PROJECTs/CORDELIA/' + '/_setting' + '/module.json') as f:
	CORDELIA_MODULE_json = json.load(f)

def extract_comma_params(string):
	elements = []
	paren_count = 0
	start = 0
	for i, c in enumerate(string):
		if c == '(':
			paren_count += 1
		elif c == ')':
			paren_count -= 1
		elif c == ',' and paren_count == 0:
			elements.append(string[start:i])
			start = i + 1
	elements.append(string[start:])
	return [elem.strip() for elem in elements if elem]

rhythm_regex = {'eu', 'hex', 'jex'}

def single_line(condition):
	def decorator(func):
		def wrapper(self):
			if len(self.lines) == 1 and condition(self):
				return func(self)
		return wrapper
	return decorator

def multi_line(condition):
	def decorator(func):
		def wrapper(self):
			if len(self.lines) > 1 and condition(self):
				return func(self)
		return wrapper
	return decorator

class Node:

	def __init__(self, node):

		# init values
		self.instrument_names = ['cordelia']
		self.routes = ['getmeout(1)']
		self.space = '0'
		self.lines = [line.rstrip().lstrip() for line in node.splitlines()]

		funcs = [func for func in dir(self) if callable(getattr(self, func)) and not func.startswith("__")]

		for func_name in funcs:
			func = getattr(self, func_name)
			val = func()
			if val:
				return
	
	@single_line(lambda self: re.search(r'^[^@].*', self.lines[0]))
	def control(self):
		self.csound_code = self.lines[0]

		return True

	@single_line(lambda self: re.search(r'^@.*', self.lines[0]))
	def seq(self):

		main_line = self.lines[0].split(':', 1)
		main_params = extract_comma_params(main_line[1])

		self.rhythm_name = 'changed2'
		self.rhythm_params = 'gkbeatn'

		self.instrument_names = re.findall(r'@(\w+)', main_line[0])

		routes_match = re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|$)', main_line[0])
		if routes_match:
			self.routes = routes_match

		space_match = re.match(r'^(.*?)@', main_line[0])
		if space_match.group(1):
			self.space = space_match.group(1)

		fade = .025
		self.dur = f'gkbeats + {fade}'
		self.dyn = main_params[1]
		self.env = 'classic'
		self.freqs = list(main_params[0])

		return True
	
	@multi_line(lambda self: self.lines[0].split(':', 1)[0] in rhythm_regex)
	def opcode_rhythm(self):

		main_line = self.lines[0].split(':', 1)

		self.rhythm_name = main_line[0]
		self.rhythm_params = extract_comma_params(main_line[1])

		self.instrument_names = re.findall(r'@(\w+)', self.lines[1])

		routes_match = re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|$)', self.lines[1])
		if routes_match:
			self.routes = routes_match

		space_match = re.match(r'^(.*?)@', self.lines[1])
		if space_match.group(1):
			self.space = space_match.group(1)

		self.dur = self.lines[2]
		self.dyn = self.lines[3]
		self.env = self.lines[4]
		self.freqs = list(self.lines[5:])

		return True


class parsing_Instrument:

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
			{'name': match.group(1), 'params': extract_comma_params(match.group(2))}
			if match else {'name': route}
			for route in routes
			if (match := re.match(r'^(\w+)\((.*?)\)$', route))
		]

		return routes_dict
	

class variable_Instrument():
		
	def __init__(self, instrument_index, parsing_Instrument):

		if parsing_Instrument.instrument_name == 'cordelia':
		
			self.__dict__.update(vars(parsing_Instrument))
			#self.instrument_index = instrument_index
			del self.instrument_name
		
		else:
			
			rhythm_var = f'gkrhy_{instrument_index}'
			self.rhythm = f'{rhythm_var} {parsing_Instrument.rhythm_name} {", ".join(parsing_Instrument.rhythm_params)}'

			if_openvar = f'\tif {rhythm_var} != 0 then\n'
			if_closevar = f'\n\tendif'

			space_var = f'gkspace_{instrument_index}'
			self.space = f'{if_openvar}{space_var} = {parsing_Instrument.space}{if_closevar}'

			name_var = f'gSname_{instrument_index}'
			self.instrument_name = f'{name_var} = "{parsing_Instrument.instrument_name}"'

			dur_var = f'gkdur_{instrument_index}'
			self.dur = f'{dur_var} = {parsing_Instrument.dur}'

			dyn_var = f'gkdyn_{instrument_index}'
			self.dyn = f'{dyn_var} = {parsing_Instrument.dyn}*({rhythm_var} == 1 ? ampdb(5) : 1)'

			env_var = f'gkenv_{instrument_index}'
			self.env = f'{env_var} = {parsing_Instrument.env}'

			self.freqs = []
			freq_vars = []
			for i in range(5):
				if i <= (len(parsing_Instrument.freqs)-1):
					#print(parsing_Instrument.freq[i])
					freq_var = f'gkfreq_{instrument_index}_{i+1}'
					freq_vars.append(freq_var)
					freq = f'{freq_var} = {parsing_Instrument.freqs[i]}'
					self.freqs.append(freq)
			
			freq_string = ", \n".join(freq_vars)

			self.instrument_index = instrument_index

			self.route = self.parse_route(parsing_Instrument.instrument_name, parsing_Instrument.routes)

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
		#route_var = f'gS{route_dict["name"]}{route_index}_{instrument_name}{self.instrument_index}_p1'
		#route_dict['params'].insert(0, (route_var, f'"{instrument_name}"'))	

		#CORE
		for route_index, route_dict in enumerate(routes_dict, start=1):

			for index_var, value in enumerate(route_dict['params']):
				route_var = f'gk{route_dict["name"]}{route_index}_{instrument_name}{self.instrument_index}_p{index_var+1}'
				route_dict['params'][index_var] = [route_var, value]

			if route_dict['name'] in CORDELIA_MODULE_json:
				#csound_cordelia.compileOrcAsync(f.read())
				string = CORDELIA_MODULE_json[route_dict['name']]['core']
				for i in range(CORDELIA_MODULE_json[route_dict['name']]['how_many_p']):
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

	
code = '''

eu: 7, 17, 8
	-r4@piano@orphans2.moij(b3, .5).tapij(23, .4)
		once(wn, 0, wn, wn, wn, 0)*2
	each(p, pp)
	classic.a(5)
		d2-4.21: mac
	f3-4.21: mac
	f4-9.23: mac

@dead3: 8, f

gkpulse = 120

eu: 7, 17, 8
	3@piano@orphans3.moij(b3, .5).strij(sda)
		once(wn, 0, wn, wn, wn, 0)*2
			each(p, pp)
	classic.a(5)
		d2-4.21: mac
	"4F"-4.21: mac
	f4-9.23: mac


gkpulse = 3ss


eu: 7, 17, 8
	3@piano@orphans3@asd.moij(b3, .5).strij(sda).tapij
		once(wn, 0, wn, wn, wn, 0)*2
			each(p, pp)
	classic.a(5)
		d2-4.21: mac
	"4F"-4.21: mac
	f4-9.23: mac


'''


# Extract nodes from code by separating them based on spaces
nodes_text = re.findall(r'^(.(?:\n|.)*?)\n$', code, flags=re.MULTILINE)

# Create Node instances for each extracted node
nodes = [Node(text) for text in nodes_text]

# Parse nodes by their names and create corresponding instruments
instrument_index = 1
instruments = []
for node in nodes:
	for instrument_name in node.instrument_names:
		print("Instrument Index:", instrument_index)
		print("Instrument Name:", instrument_name)

		# Create parsing_Instrument instance
		par_instrument = parsing_Instrument(instrument_name, node)

		#print(parsing_Instrument.routes)
		# Create Instrument instance
		var_instrument = variable_Instrument(instrument_index, par_instrument)
		instruments.append(var_instrument)
		instrument_index += 1

for i in instruments:
	pprint.pprint(vars(i))