from src.instrumenter import Instrument, postInstrument
from src.lexer import Token

def remove_sequence(tokens, start_type, end_type):
	start_index = next((i for i, token in enumerate(tokens) if token.type in start_type), None)
	if start_index is None:
		return tokens, list() # No matching start type found, return the original tokens
	
	end_index = next((i for i, token in enumerate(tokens[start_index:]) if token.type in end_type), None)
	if end_index is None:
		return tokens, list() # No matching end type found, return the original tokens
	
	end_index += start_index + 1  # Adjust end_index based on start_index

	sequence = tokens[:start_index] + tokens[end_index:]
	extracted_sequence = tokens[start_index:end_index]

	return sequence, extracted_sequence


def extract_comma(tokens):
	tokens_nocomma = []
	open_paren_count = 0
	start_index = 0
	for i, token in enumerate(tokens):
		if token.type == 'LPAREN':
			open_paren_count += 1
		elif token.type == 'RPAREN':
			open_paren_count -= 1
		elif token.type == 'COMMA' and open_paren_count == 0:
			tokens_nocomma.append(''.join(t.value for t in tokens[start_index:i]))
			start_index = i + 1

	# Appending remaining tokens after the last comma or if no commas found
	tokens_nocomma.append(''.join(t.value for t in tokens[start_index:]))

	return tokens_nocomma

def extract_sequence(tokens, start_type, end_type, include_start=False, include_end=False, include_paren=True):
	sequence = []
	start_index = 1
	inside_sequence = False
	
	for i, token in enumerate(tokens):
		if token.type in start_type and not inside_sequence:
			start_index += i
			if include_start:
				sequence.append(token)
				start_index -= 1
			inside_sequence = True
		elif token.type in end_type:
			if include_end:
				sequence.append(token)
			break
		elif inside_sequence:
			sequence.append(token)
	
	if not include_paren:
		sequence = sequence[1:-1]
		start_index += 2

	return extract_comma(sequence), tokens[start_index+len(sequence):]

def print_tokens(tokens):
	print('-'*40)
	for token in tokens:
		if token.type != 'NEWLINE' and token.type != 'EMPTYLINE':
			print(token.type, '   \t', '.'*30, token.value)
		else:
			print(token.type)
	print('-'*40)

def condition(condition_data):
	def decorator(func):
		func.condition_data = condition_data
		return func
	return decorator

class Parser:

	def __init__(self, tokens):

		self.tokens = tokens
		#self.print_tokens(self.tokens)

		self.parse_func = []
		for attr_name in dir(self):
			if attr_name.startswith('parse_'):
				self.parse_func.append(attr_name)

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

	# ============
	# MAIN PARSE FUNC
	# ============
	def parse(self):

		while self.tokens:
			token = self.tokens.pop(0)

			for condition_func, condition in self.conditions.items():
				selected_tokens = []
				if token.type in condition['start']:
					selected_tokens.append(token)

					while self.tokens and self.tokens[0].type not in condition['end']:
						selected_tokens.append(self.tokens.pop(0))

					func = getattr(self, condition_func)
					func(selected_tokens)
					break

	@condition({'start': 'COMMENT', 'end': 'EMPTYLINE'})
	def parse_comment(self, main_tokens):
		pass

	@condition({'start': 'RHYTHM', 'end': 'EMPTYLINE'})
	def parse_rhythmic_seq(self, main_tokens):
		main_tokens.append(Token('EOF', ''))
		main_tokens, ex = remove_sequence(main_tokens, start_type='COMMENT', end_type='NEWLINE')

		names = [token.value for token in main_tokens if token.type == 'INSTR']
		for name in names:
			tokens = list(main_tokens) # Make a copy
			instrument = Instrument(name)

			instrument.rhythm = {'name': next((token.value for token in tokens if token.type == 'RHYTHM'), None)}
			instrument.rhythm['params'], tokens  = extract_sequence(tokens, start_type='RHYTHM', end_type='NEWLINE')
			instrument.space, tokens = extract_sequence(tokens, start_type='NEWLINE', end_type='INSTR')

			instrument.routing = []
			for token in tokens:
				if token.type == 'ROUTING':
					params, tokens = extract_sequence(tokens, start_type='ROUTING', end_type=['ROUTING', 'NEWLINE'], include_paren=False)
					instrument.routing.append({'name': token.value, 'params': params})
			

			instrument.dur, tokens = extract_sequence(tokens, start_type='NEWLINE', end_type='NEWLINE')
			instrument.dyn, tokens = extract_sequence(tokens, start_type='NEWLINE', end_type='NEWLINE')
			instrument.env, tokens = extract_sequence(tokens, start_type='NEWLINE', end_type='NEWLINE')

			instrument.freq = []
			for token in tokens:
				if tokens:
					freqs, tokens = extract_sequence(tokens, start_type='NEWLINE', end_type='NEWLINE')
					instrument.freq.extend(freqs)
				
			self.instruments.append(instrument)

	@condition({'start': 'INSTR', 'end': ['EMPTYLINE', 'NEWLINE']})
	def parse_sonvs_seq(self, main_tokens):
		names = [token.value for token in main_tokens if token.type == 'INSTR']

		for name in names:
			tokens = list(main_tokens) # Make a copy
			instrument = Instrument(name)
			
			instrument.routing = []
			for token in tokens:
				if token.type == 'ROUTING':
					params, tokens = extract_sequence(tokens, start_type='ROUTING', end_type=['ROUTING', 'COLON'], include_paren=False)
					instrument.routing[token.value] = params
			
			tokens.pop(0) # Remove 'COLON'
			params = extract_comma(tokens)
			instrument.space, tokens = extract_sequence(tokens, start_type='NEWLINE', end_type='INSTR')
			instrument.freq = params[0]
			instrument.dyn = params[1] if len(params) > 1 else 'mf'

			# Custom for sonvs_seq
			instrument.rhythm = {'changed2': 'gkbeatn'}
			fade = '.035'
			instrument.dur = f'gkbeats + {fade}'
			instrument.env = fade

			self.instruments.append(instrument)

	@condition({'start': ['GKVAR', 'GIVAR'], 'end': ['EMPTYLINE', 'NEWLINE']})
	def parse_csound_command(self, tokens):
		code = ''.join(token.value for token in tokens)
		instrument = Instrument('cordelia')
		instrument.csound_code = code
		self.instruments.append(instrument)

	def get_instruments(self):

		post_instruments = []
		index_id = 1
		for i in self.instruments:
			i.index = index_id
			i.converter()
			i.make_variables()

			for post_attr in i.get_attributes():
				if isinstance(post_attr, list):
					for post in post_attr:
						post_instruments.append(postInstrument(i.index, post))
				else:
					post_instruments.append(postInstrument(i.index, post_attr))

			index_id += 1

		return post_instruments