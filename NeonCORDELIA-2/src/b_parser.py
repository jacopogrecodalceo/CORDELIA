from src.instrument import Instrument
from src.a_lexer import Token

from constants.var import cordelia_json, default_sonvs
from constants.var import cordelia_init_code, cordelia_given
from csoundAPI.init_csound import cordelia_nchnls

PRINT_TOKEN = False

names_last = {}

def verify(token):

	type = token.type

	if type == 'SCALA':
		# Remove 'scala.'
		value = token.value.replace('scala.', '')
		if value not in cordelia_given:
			cordelia_given.append(value)
			if value in cordelia_json[type]:
				print(f'📩{value} is verified.')
				cordelia_init_code.append(cordelia_json[type][value]['default_ftgen'])
				token.value = 'gi' + value
				return token
			else:
				raise ValueError(f'{type} with {value} is not found!')
		else:
			token.value = 'gi' + value
			return token

	elif type == 'INSTR':
		# Remove '@'
		value = token.value[1:]
		if value not in cordelia_given:
			cordelia_given.append(value)
			if value in cordelia_json[type]:
				print(f'📩{value} is verified.')
				verify_instr(value)
				#cordelia_json[type][value]['type']
				#cordelia_init_code.append(cordelia_json[type][value]['path'])
				token.value = value
				return token
			else:
				raise ValueError(f'{type} with {value} is not found!')
		else:
			token.value = value
			return token

	elif type == 'RHYTHM':
		# Remove the ':'
		value = token.value[:-1]
		token.value = value
		return token

	elif type == 'ROUTING':
		# Remove the '.'
		value = token.value[1:]
		if value in cordelia_json[type]:
			token.value = value
			return token
		else:
			raise ValueError(f'{type} with {value} is not found!')

	elif type == 'WORD':
		value = token.value

		if value in cordelia_json['GEN']:
			if value not in cordelia_given:
				cordelia_given.append(value)
				print(f'📩{value} is verified.')
				cordelia_init_code.append(cordelia_json['GEN'][value])
				token.value = 'gi' + value
				return token
			else:
				token.value = 'gi' + value
				return token

		elif value in cordelia_json['MODE']:
			if value not in cordelia_given:
				cordelia_given.append(value)
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

	else:
		return token

def verify_instr(instrument_name):
	
	local_json = cordelia_json['INSTR']

	if local_json[instrument_name]['type'] == 'instr':
		with open(local_json[instrument_name]['path']) as f:
			cordelia_init_code.append(f.read())

	elif local_json[instrument_name]['type'] == 'hybrid':
		required_instr = local_json[instrument_name]['required']
		for i in required_instr:
			if i not in cordelia_given:
				verify_instr(i)
		with open(local_json[instrument_name]['path']) as f:
			cordelia_init_code.append(f.read())

	elif local_json[instrument_name]['type'] == 'sonvs':
		channels = local_json[instrument_name]['channels']
		sonvs_string = [f'gi{instrument_name}_ch init {channels}']
		index_num = 1
		audio_files = []

		for index, p in enumerate(local_json[instrument_name]['path']):
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

		for key in default_sonvs.keys():
			if instrument_name.endswith(key):
				sonvs_string.append(default_sonvs[key].replace('---NAME---', instrument_name))
			else:
				sonvs_string.append(default_sonvs['_'].replace('---NAME---', instrument_name))
				break

		cordelia_init_code.append('\n'.join(sonvs_string))

	#and create an array
	instr_setting = [f'gS{instrument_name}[] init ginchnls']
	for each in range(cordelia_nchnls):
		instr_setting.append(f'gS{instrument_name}[{each}] sprintf	"{instrument_name}_%i", {each+1}')

	start = cordelia_nchnls * (len(cordelia_given) - 1) + 1
	sequence = [start + i for i in range(cordelia_nchnls)]
	for index, val in enumerate(sequence):
		instr_num = 950 + (val/10000)
		instr_setting.append(f'schedule {round(instr_num, 5)}, 0, -1, "{instrument_name}_{index+1}"')
		
	cordelia_init_code.append('\n'.join(instr_setting))

def remove_comment(tokens):
	start_types = 'COMMENT'
	end_types = 'NEWLINE'
	start_index = next((i for i, token in enumerate(tokens) if token.type in start_types), None)
	if start_index is None:
		return tokens, list() # No matching start type found, return the original tokens
	
	end_index = next((i for i, token in enumerate(tokens[start_index:]) if token.type in end_types), None)
	if end_index is None:
		return tokens, list() # No matching end type found, return the original tokens
	
	end_index += start_index

	sequence = tokens[:start_index] + tokens[end_index:]
	extracted_sequence = tokens[start_index:end_index]

	return sequence, extracted_sequence

def extract_comma(tokens):
	tokens_without_comma = []
	open_paren_count = 0
	start_index = 0
	for i, token in enumerate(tokens):
		if token.type == 'LPAREN':
			open_paren_count += 1
		elif token.type == 'RPAREN':
			open_paren_count -= 1
		elif token.type == 'COMMA' and open_paren_count == 0:
			tokens_without_comma.append(''.join(t.value for t in tokens[start_index:i]))
			start_index = i + 1

	# Appending remaining tokens after the last comma or if no commas found
	tokens_without_comma.append(''.join(t.value for t in tokens[start_index:]))

	return tokens_without_comma

def extract_sequence(tokens, start_types, end_types, include_start=False, include_end=False, include_paren=True):
	sequence = []
	start_index = 0
	inside_sequence = False
	
	for i, token in enumerate(tokens):
		if token.type in start_types and not inside_sequence:
			start_index = i
			if include_start:
				sequence.append(token)
				start_index -= 1
			inside_sequence = True
		elif token.type in end_types and inside_sequence:
			if include_end:
				sequence.append(token)
			break
		elif inside_sequence:
			sequence.append(token)
	
	if not include_paren and sequence[0].type == 'LPAREN' and sequence[-1].type == 'RPAREN':
		sequence = sequence[1:-1]
		start_index += 1

	return extract_comma(sequence), tokens[start_index + len(sequence) + 1:]

def print_tokens(tokens):
	print('-'*40)
	for token in tokens:
		if token.type != 'NEWLINE' and token.type != 'EMPTYLINE':
			print(token.type, '   \t', '.'*30, token.value)
		else:
			print(token.type)
	print('-'*40)

def print_token(token):
	if token.type != 'NEWLINE' and token.type != 'EMPTYLINE':
		print(token.type, '   \t', '.'*30, token.value)
	else:
		print(token.type)

def condition(condition_data):
	def decorator(func):
		func.condition_data = condition_data
		return func
	return decorator

class Parser:

	def __init__(self, tokens):

		self.tokens = tokens
		self.conditions = self.gather_conditions()
		self.instruments = []

	def gather_conditions(self):
			conditions = {}
			methods = [getattr(self, method) for method in dir(self) if callable(getattr(self, method)) and method.startswith('parse_')]
			for method in methods:
				method_name = method.__name__
				if hasattr(method, 'condition_data'):
					conditions[method_name] = method.condition_data
			return conditions

	def parse(self):
		while self.tokens:
			token = verify(self.tokens.pop(0))
			
			if PRINT_TOKEN:
				print_token(token)

			for condition_func, condition in self.conditions.items():
				selected_tokens = []
				if token.type in condition['start']:
					selected_tokens.append(token)

					while self.tokens and self.tokens[0].type not in condition['end']:
						token = verify(self.tokens.pop(0))
						selected_tokens.append(token)
						if PRINT_TOKEN:
							print_token(token)

					func = getattr(self, condition_func)
					func(selected_tokens)
					break


	# ================
	# PARSE CONDITIONs
	# ================

	@condition({'start': 'COMMENT', 'end': 'EMPTYLINE'})
	def parse_comment(self, _):
		pass

	@condition({'start': 'RHYTHM', 'end': 'EMPTYLINE'})
	def parse_rhythmic_seq(self, tokens):
		tokens, _ = remove_comment(tokens)

		tokens.insert(0, Token('SOC', None))
		tokens.insert(len(tokens), Token('EOC', None))

		names = [token.value for token in tokens if token.type == 'INSTR']
		rhythm = {'name': next((token.value for token in tokens if token.type == 'RHYTHM'), None)}
		rhythm['params'], tokens  = extract_sequence(tokens, start_types='RHYTHM', end_types='NEWLINE')
		space, tokens = extract_sequence(tokens, start_types='NEWLINE', end_types='INSTR')

		routing = []
		for token in tokens:
			if token.type == 'ROUTING':
				params, tokens = extract_sequence(tokens, start_types='ROUTING', end_types=['ROUTING', 'NEWLINE'], include_paren=False)
				routing.append({'name': token.value, 'params': params})
		dur, tokens = extract_sequence(tokens, start_types='NEWLINE', end_types='NEWLINE')
		dyn, tokens = extract_sequence(tokens, start_types='NEWLINE', end_types='NEWLINE')
		env, tokens = extract_sequence(tokens, start_types='NEWLINE', end_types='NEWLINE')

		freq = []
		for token in tokens:
			if tokens:
				freqs, tokens = extract_sequence(tokens, start_types='NEWLINE', end_types=['NEWLINE', 'EOC'])
				if freqs[0]:
					freq.extend(freqs)
			
		for name in names:
			instrument = Instrument()

			instrument.rhythm = rhythm
			instrument.space = space
			instrument.name = name
			instrument.routing = routing
			instrument.dur = dur
			instrument.dyn = dyn
			instrument.env = env
			instrument.freq = freq

			self.instruments.append(instrument)

	@condition({'start': 'INSTR', 'end': ['EMPTYLINE', 'NEWLINE']})
	def parse_sonvs_seq(self, tokens):

		tokens.insert(0, Token('SOC', None))
		tokens.insert(len(tokens), Token('EOC', None))

		names = [token.value for token in tokens if token.type == 'INSTR']
		
		routing = []
		for token in tokens:
			if token.type == 'ROUTING':
				params, tokens = extract_sequence(tokens, start_types='ROUTING', end_types=['ROUTING', 'COLON'], include_start=False, include_end=False, include_paren=False)
				routing.append({'name': token.value, 'params': params})
		params, tokens = extract_sequence(tokens, start_types='COLON', end_types='EOC', include_start=False, include_end=False, include_paren=True)

		for name in names:
			instrument = Instrument()

			instrument.space = 0
			instrument.name = name
			instrument.routing = routing
			instrument.freq = [params[0]]
			instrument.dyn = [params[1]] if len(params) > 1 else ['mf']

			# Custom for sonvs_seq
			instrument.rhythm = {'name': 'changed2', 'params': 'gkbeatn'}
			fade = '.035'
			instrument.dur = f'gkbeats + {fade}'
			instrument.env = fade

			self.instruments.append(instrument)

	@condition({'start': ['GKVAR', 'GIVAR'], 'end': ['EMPTYLINE', 'NEWLINE']})
	def parse_csound_command(self, tokens):
		code = ''.join(token.value for token in tokens)
		instrument = Instrument()
		instrument.name = 'cordelia'
		instrument.code = code
		self.instruments.append(instrument)

	def get_instruments(self):

		#global names_last

		self.parse()

		name_counts = {}
		instruments = []

		for i in self.instruments:
			# ----------------------------------------------------------------
			name = i.name
			name_count = name_counts.get(name, 0) + 1
			name_counts[name] = name_count
			name_var = f'{name}_{name_count}'
			if name_var in names_last:
				i.name_id = names_last[name_var]
			else:
				i.name_id = len(names_last) + 1
				names_last[name_var] = i.name_id
			# ----------------------------------------------------------------
		""" print('-'*90)
		print(name_counts)
		print(names_last)
		print('-'*90) """
		for i in self.instruments:
			i.spell()
			i.make_variables()

			for attr in i.get_attributes():
				if isinstance(attr, list):
					for a in attr:
						instrument = Instrument()
						instrument.index = i.name_id
						instrument.code = a
						instruments.append(instrument)
				else:
					if attr != 'cordelia':
						instrument = Instrument()
						instrument.index = i.name_id
						instrument.code = attr
						instruments.append(instrument)

		self.instruments.clear()

		return instruments