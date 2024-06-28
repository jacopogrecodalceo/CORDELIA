import pprint

from constants.var import *

from constants.var import cordelia_json
from constants.var import cordelia_init_code, cordelia_given_else, cordelia_given_instr
from csoundAPI.cs import cordelia_nchnls

from csoundAPI.cs import remember, csound_clear_instrument

from src.lexer import print_tokens, print_token, Token, tokenize

PRINT_TOKENS = False

def extract_keyword_from_list(list_params, keyword):
	for element in list_params:
		if keyword in element:
			extracted = element.replace(keyword, '')
			list_params.remove(element)
			return list_params, extracted
	return list_params, None


def extract_csv(string):
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

# =================================================================
# =================================================================
# =================================================================

def verify(tokens):
	for i, token in enumerate(tokens):
		function_name = f'verify_{token.type.lower()}'
		func = globals().get(function_name)
		if func:
			tokens[i] = func(token)

	return tokens

def verify_scala(token):
	# Remove 'scala.'
	value = token.value.replace('scala.', '')
	if value not in cordelia_given_else:
		cordelia_given_else.append(value)
		if value in cordelia_json[token.type]:
			print(f'📩{value} is verified.')
			cordelia_init_code.append(cordelia_json[token.type][value]['default_ftgen'])
			token.value = 'gi' + value
			return token
		else:
			print(f'Error: {token.type} with {value} is not found!')
	else:
		token.value = 'gi' + value
		return token

def verify_instr(token):
	
	def include_instr(instr_json):
		with open(instr_json['path']) as f:
			cordelia_init_code.append(f.read())

	def include_hybrid(instr_json):
		required_instr = instr_json['required']
		for i in required_instr:
			if i not in cordelia_given_instr:
				send_instr(i)
		with open(instr_json['path']) as f:
			cordelia_init_code.append(f.read())
		
	def include_sonvs(instr_json, instrument_name):
		channels = instr_json['channels']
		sonvs_string = [f'gi{instrument_name}_ch init {channels}']
		index_num = 1
		audio_files = []

		for index, p in enumerate(instr_json['path']):
			index_file = index + 1
			sonvs_string.append(f'gS{instrument_name}_file_{index_file} init "{p}"')
			for i in range(int(channels)):
				ch = str(i + 1)
				num = str(index_num)
				file_var = f'gi{instrument_name}_{num}'
				audio_files.append(file_var)
				sonvs_string.append(f'{file_var} ftgen 0, 0, 0, 1, gS{instrument_name}_file_{index_file}, 0, 0, {ch}')
				index_num += 1

		sonvs_string.append(f'gi{instrument_name}_list[] fillarray {", ".join(audio_files)}')

		with open(instr_json['orc'], 'r') as f:
			code = f.read()
			code = code.replace('---NAME---', instrument_name)
			code = code.replace('---PITCH---', instr_json['pitch'])
			sonvs_string.append(code)

		cordelia_init_code.append('\n'.join(sonvs_string))
	
	def create_instr_setting(instrument_name):
		instr_setting = [f'gS{instrument_name}[] init ginchnls']
		for i in range(cordelia_nchnls):
			instr_setting.append(f'gS{instrument_name}[{i}] sprintf	"{instrument_name}_%i", {i+1}')

		instr_setting.extend(csound_clear_instrument(instrument_name))
		
		do_u_remember = remember(instrument_name)
		if do_u_remember:
			instr_setting.append(do_u_remember)
			
		cordelia_init_code.append('\n'.join(instr_setting))

	def send_instr(instrument_name):
		
		instr_json = cordelia_json['INSTR'][instrument_name]

		if instr_json['type'] == 'instr':
			include_instr(instr_json)

		elif instr_json['type'] == 'hybrid':
			include_hybrid(instr_json)

		elif instr_json['type'] == 'sonvs' or instr_json['type'] == 'dir_sonvs':
			include_sonvs(instr_json, instrument_name)

		create_instr_setting(instrument_name)

	# Remove '@'
	value = token.value[1:]
	if value not in cordelia_given_instr:
		cordelia_given_instr.append(value)
		if value in cordelia_json[token.type]:
			print(f'📩{value} is verified.')
			send_instr(value)
			#cordelia_json[type][value]['type']
			#cordelia_init_code.append(cordelia_json[type][value]['path'])
			token.value = value
			return token
		else:
			raise ValueError(f'{token.type} with {value} is not found!')
	else:
		token.value = value
		return token

def verify_rhythm(token):
	# Remove the ':'
	value = token.value[:-1]
	token.value = value
	return token

def verify_routing(token):
	# Remove the '.'
	value = token.value[1:]
	if value not in cordelia_given_else:
		cordelia_given_else.append(value)
		if value in cordelia_json[token.type]:
			print(f'📩{value} is verified.')
			opcode = cordelia_json[token.type][value]['opcode']
			if opcode:
				cordelia_init_code.append(opcode)
			token.value = value
			return token
		else:
			raise ValueError(f'{token.type} with {value} is not found!')
	else:
		token.value = value
		return token


def verify_word(token):
	value = token.value

	if value in cordelia_json['GEN']:
		if value not in cordelia_given_else:
			cordelia_given_else.append(value)
			print(f'📩{value} is verified.')
			cordelia_init_code.append(cordelia_json['GEN'][value])
			token.value = 'gi' + value
			return token
		else:
			token.value = 'gi' + value
			return token

	elif value in cordelia_json['MODE']:
		if value not in cordelia_given_else:
			cordelia_given_else.append(value)
			print(f'📩{value} is verified.')
			values = cordelia_json['MODE'][value]
			code = f'gi{value} ftgen 0,0,0,-2,' + values
			cordelia_init_code.append(code)
			token.value = 'gi' + value
			return token
		else:
			token.value = 'gi' + value
			return token

	return token

# =================================================================
# =================================================================
# =================================================================

condition_data = {} # Create a dictionary to store condition data

def condition(condition_data_dict):
	def decorator(func):
		# Store the condition data in the dictionary with the function name as the key
		condition_data[func.__name__] = condition_data_dict
		return func
	return decorator

def parse_comments(tokens):
	i = 0
	while i < len(tokens):
		token = tokens[i]

		if token.type in ['COMMENT']:
			selected_tokens = [token]

			j = i + 1
			while j < len(tokens) and tokens[j].type not in ['NEWLINE', 'EMPTYLINE']:
				selected_tokens.append(tokens[j])
				j += 1

			# Remove selected_tokens from tokens
			tokens = tokens[:i] + tokens[j:]

		else:
			i += 1

	return tokens



def parse_by_group(tokens):

	grouped_tokens = []

	""" i = 0
	while i < len(tokens):
		token = tokens[i]
		for func_name, condition in condition_data.items():
			if token.type in condition['start']:
				selected_tokens = [token]

				j = i + 1
				while j < len(tokens) and tokens[j].type not in condition['end']:
					selected_tokens.append(tokens[j])
					j += 1

				grouped_tokens.append((func_name, selected_tokens))

				# Remove selected_tokens from tokens
				tokens = tokens[:i] + tokens[j:]

			else:
				i += 1 """
	while tokens:
		token = tokens.pop(0)

		if PRINT_TOKENS:
			print_token(token)

		for condition_func, condition in condition_data.items():
			selected_tokens = []
			if token.type in condition['start']:
				selected_tokens.append(token)

				while tokens and tokens[0].type not in condition['end']:
					token = tokens.pop(0)
					selected_tokens.append(token)
					if PRINT_TOKENS:
						print_token(token)

				grouped_tokens.append((condition_func, selected_tokens))
				break
	return grouped_tokens

# =================================================================
# =================================================================
# =================================================================

class Instrument:
	def __init__(self, rhythm=None, space=None, name=None, routing=None, dur=None, dyn=None, env=None, freq=None, wrap=True, num=None):
		self.rhythm = rhythm
		self.space = space
		self.name = name
		self.routing = routing
		self.dur = dur
		self.dyn = dyn
		self.env = env
		self.freq = freq
		self.wrap = wrap
		self.num = num

# =================================================================
# =================================================================
# =================================================================

def parse(grouped_tokens):

	instruments = []

	for func_name, tokens in grouped_tokens:
		if PRINT_TOKENS:
			print(func_name)
			print_tokens(tokens)
		func = globals().get(func_name)
		if func:
			instrument = func(tokens)
			if instrument:
				instruments.extend(instrument)

	return instruments

# =================================================================
# =================================================================
# =================================================================

def extract_sequence(tokens, start=None, end=None, include_start=True, include_end=False):
	start_index = 0
	end_index = len(tokens)

	for index, token in enumerate(tokens):
		if start and token.type in start:
			start_index = index
			break

	enumerate_index = start_index + 1 if start else 0
	for index, token in enumerate(tokens[enumerate_index:], start=enumerate_index):
		if end and token.type in end:
			end_index = index
			break

	start_index += 0 if include_start else 1
	end_index += int(include_end)  # Add 1 if include_end is True

	extracted_sequence = [token.value for token in tokens[start_index:end_index]]

	return extracted_sequence, tokens[end_index:]#tokens[end_index + 1:] if tokens[end_index:][0].type == 'NEWLINE' else tokens[end_index:]

# =================================================================
# =================================================================
# =================================================================
# PAY ATTENTION TO THE ORDER OF THESE FUNCTIONS
# =================================================================
# =================================================================
# =================================================================

@condition({'start': ['REAPER'], 'end': ['REAPER']})
def parse_reaper(tokens):
	if tokens[0].value.startswith('REAPER_INSTR_START'):
		instrument_num = tokens[1].value
		tokens = tokens[2:]
		grouped_tokens = parse_by_group(tokens)
		for func_name, tokens in grouped_tokens:
			func = globals().get(func_name)
			if func:
				instrument = func(tokens)
				instrument[0].num = instrument_num
				return [instrument[0]]


@condition({'start': ['RHYTHM'], 'end': ['EMPTYLINE']})
def parse_rhythmic(tokens):

	instruments = []

	"""Retrive instrument names before tokens are eaten"""
	names = [token.value for token in tokens if token.type == 'INSTR']

	"""Extract differnet sequences as a list or a string"""
	rhythm_sequence, tokens = extract_sequence(tokens, start=['RHYTHM'], end=['NEWLINE'])
	space_sequence, tokens = extract_sequence(tokens, start=['NEWLINE'], end=['INSTR'], include_start=False)
	
	routings = []
	for _ in [token.value for token in tokens if token.type == 'ROUTING']:
		routing_sequence, tokens = extract_sequence(tokens, start=['ROUTING'], end=['ROUTING', 'NEWLINE'])
		routings.append({'name': routing_sequence[0], 'params': extract_csv(''.join(routing_sequence[2:-1]))})

	dur_sequence, tokens = extract_sequence(tokens, start=['NEWLINE'], end=['NEWLINE'], include_start=False)
	dyn_sequence, tokens = extract_sequence(tokens,start=['NEWLINE'],  end=['NEWLINE'], include_start=False)
	env, tokens = extract_sequence(tokens, start=['NEWLINE'], end=['NEWLINE'], include_start=False)

	freqs = []
	while tokens:
		freq_sequence, tokens = extract_sequence(tokens, start=['NEWLINE'], end=['NEWLINE'], include_start=False)
		freqs.append(''.join(freq_sequence))

	for name in names:
		instrument = Instrument(
			rhythm={'name': rhythm_sequence[0], 'params': extract_csv(''.join(rhythm_sequence[1:]))},
			space=''.join(space_sequence) if space_sequence else '0',
			name=name,
			routing= routings if routings else [{'name': 'getmeout', 'params': '1'}],
			dur=extract_csv(''.join(dur_sequence)),
			dyn=extract_csv(''.join(dyn_sequence)),
			env=''.join(env),
			freq=freqs,
			wrap=True
		)
		instruments.append(instrument)

	return instruments

@condition({'start': ['INSTR', 'ROUTING'], 'end': ['EMPTYLINE']})
def parse_sonvs_routing(tokens):

	def parse_sonvs(tokens):
		instruments = []
		custom_sonvs_fade = .035

		"""Retrive instrument names before tokens are eaten"""
		names = [token.value for token in tokens if token.type == 'INSTR']

		"""Extract differnet sequences as a list or a string"""
		space_sequence, tokens = extract_sequence(tokens, end=['INSTR'])

		routings = []
		for _ in [token.value for token in tokens if token.type == 'ROUTING']:
			routing_sequence, tokens = extract_sequence(tokens, start=['ROUTING'], end=['ROUTING', 'COLON'])
			routings.append({'name': routing_sequence[0], 'params': extract_csv(''.join(routing_sequence[2:-1]))})

		params_sequence, tokens = extract_sequence(tokens, start=['COLON'], end=['NEWLINE'], include_start=False)
		params_sequence = extract_csv(''.join(params_sequence))

		for name in names:
			instrument = Instrument(
				rhythm={'name': 'changed2', 'params': 'gkbeatn'},
				space=''.join(space_sequence) if space_sequence else '0',
				name=name,
				routing= routings if routings else [{'name': 'getmeout', 'params': '1'}],
				dur=f'gkbeats + {custom_sonvs_fade}',
				dyn=params_sequence[1] if len(params_sequence) > 1 else 'mf',
				env=str(custom_sonvs_fade),
				freq=[params_sequence[0]],
				wrap=True
			)
			instruments.append(instrument)
		
		return instruments

	def parse_routing(tokens):
		"""Exemple: .getmeout(@aaron, 1) --- this is tipically used with reaper or to keep open an instrument"""

		instrument_num = None

		tokens.append(Token('NEWLINE', None))

		if 'INSTR' not in [token.type for token in tokens]:
			raise ValueError('Missing instrument name in routing')

		routings = []
		for _ in [token.value for token in tokens if token.type == 'ROUTING']:
			routing_sequence, tokens = extract_sequence(tokens, start=['ROUTING'], end=['ROUTING', 'NEWLINE'])
			routing_name = routing_sequence[0]
			routing_params = extract_csv(''.join(routing_sequence[2:-1])) # Removing parentheses

			routing_params, extract_num = extract_keyword_from_list(routing_params, 'num=')
			routing_params, extract_sched_onset = extract_keyword_from_list(routing_params, 'sched_onset=')
			routing_params, extract_sched_dur = extract_keyword_from_list(routing_params, 'sched_dur=')

			instrument_name = routing_params[0]
			routing_params = routing_params[1:]
			routings.append({'name': routing_name, 'params': routing_params})

		instrument = Instrument(
			name=instrument_name,
			routing= routings if routings else [{'name': 'getmeout', 'params': '1'}],
			wrap=True,
			num=extract_num if extract_num else None
		)
		if extract_sched_dur:
			instrument.sched_dur = extract_sched_dur
		
		if extract_sched_onset:
			instrument.sched_onset = extract_sched_onset
		
		return [instrument]

	if tokens[0].type == 'INSTR':
		return parse_sonvs(tokens)

	elif tokens[0].type == 'ROUTING':
		return parse_routing(tokens)

@condition({'start': ['CSOUND_OPCODE_K'], 'end': ['EMPTYLINE']})
def parse_csound_k(tokens):

	tokens = [Token(token.type, f'"{token.value}"') if token.type == 'INSTR' else token for token in tokens]
	code = f'{tokens[0].value} {"".join([token.value for token in tokens[1:]])}'

	instrument = Instrument(
		name='cordelia',
		wrap=True
	)
	instrument.code = code

	return [instrument]

@condition({'start': ['CSOUND_OPCODE_INIT'], 'end': ['EMPTYLINE']})
def parse_csound_i(tokens):

	tokens = [Token(token.type, f'"{token.value}"') if token.type == 'INSTR' else token for token in tokens]
	code = f'{tokens[0].value} {"".join([token.value for token in tokens[1:]])}'

	instrument = Instrument(
		name='cordelia',
		wrap=False
	)
	instrument.code = code

	return [instrument]
