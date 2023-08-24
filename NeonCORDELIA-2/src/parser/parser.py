from src.lexer import Token, Tokenizer
from src.commit import commit_to_csound
from src.instrumenter import Instrument

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

def extract_params_until_newline(tokens):
	tokens_nocomma = []
	open_paren_count = 0
	start_index = 0
	for i, token in enumerate(tokens):
		if token.type == 'NEWLINE':
			tokens_nocomma.append(''.join(t.value for t in tokens[start_index:i]))
			break
		elif token.type == 'LPAREN':
			open_paren_count += 1
		elif token.type == 'RPAREN':
			open_paren_count -= 1
		elif token.type == 'COMMA' and open_paren_count == 0:
			tokens_nocomma.append(''.join(t.value for t in tokens[start_index:i]))
			start_index = i + 1

	return tokens_nocomma

def extract_params(tokens, start_type='NEWLINE', end_type='NEWLINE', include_start=False, include_end=False):
	remaining_tokens = []

	open_paren_count = 0
	extraction_start_index = None
	inside_extraction = False

	for i, token in enumerate(tokens):
		if token.type == start_type:
			inside_extraction = True
			extraction_start_index = i + (0 if include_start else 1)  # Start including from start_token_type
			open_paren_count = 0  # Reset open parenthesis count

		if inside_extraction:
			if token.type == 'LPAREN':
				open_paren_count += 1
			elif token.type == 'RPAREN':
				open_paren_count -= 1
			elif token.type in end_type and open_paren_count == 0:
				tokens_nocomma = [t.value for t in tokens[extraction_start_index:i + (1 if include_end else 0)]]
				remaining_tokens = tokens[i + (1 if include_end else 0):]  # Remaining tokens after end_token_type
				break

	return tokens_nocomma, remaining_tokens

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

	def __init__(self, input_code):

		tokenizer = Tokenizer(input_code)

		tokens = tokenizer.get_tokens()
		self.tokens = commit_to_csound(tokens)
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
		print_tokens(main_tokens)
		_, tokens = extract_sequence(main_tokens, start_type='COMMENT', end_type='NEWLINE')

		names = [token.value for token in main_tokens if token.type == 'INSTR']
		for name in names:
			tokens = list(main_tokens) # Make a copy
			instrument = Instrument(name)

			rhythm_name = next((token.value for token in tokens if token.type == 'RHYTHM'), None)
			instrument.rhythm[rhythm_name], tokens  = extract_sequence(tokens, start_type='RHYTHM', end_type='NEWLINE')
			instrument.space, tokens = extract_sequence(tokens, start_type='NEWLINE', end_type='INSTR')

			for token in tokens:
				if token.type == 'ROUTING':
					params, tokens = extract_sequence(tokens, start_type='ROUTING', end_type=['ROUTING', 'NEWLINE'], include_paren=False)
					instrument.rounting[token.value] = params
			

			instrument.dur, tokens = extract_sequence(tokens, start_type='NEWLINE', end_type='NEWLINE')
			instrument.dyn, tokens = extract_sequence(tokens, start_type='NEWLINE', end_type='NEWLINE')
			instrument.env, tokens = extract_sequence(tokens, start_type='NEWLINE', end_type='NEWLINE')

			for token in tokens:
				if tokens:
					freqs, tokens = extract_sequence(tokens, start_type='NEWLINE', end_type='NEWLINE')
					instrument.freq.append(freqs)
				
			self.instruments.append(instrument)

	@condition({'start': 'INSTR', 'end': ['EMPTYLINE', 'NEWLINE']})
	def parse_sonvs_seq(self, main_tokens):
		names = [token.value for token in main_tokens if token.type == 'INSTR']

		for name in names:
			tokens = list(main_tokens) # Make a copy
			instrument = Instrument(name)
			while tokens:
				if tokens[0].type == 'COLON':
					tokens.pop(0) # Remove the 'COLON'
					params = extract_comma(tokens)
					instrument.freq = params[0]
					instrument.dyn = params[1] if len(params) > 1 else 'mf'
					break
				tokens.pop(0)
					
			self.instruments.append(instrument)

	@condition({'start': ['GKVAR', 'GIVAR'], 'end': ['EMPTYLINE', 'NEWLINE']})
	def parse_csound_command(self, tokens):
		code = ' '.join(token.value for token in tokens)
		instrument = Instrument('cordelia')
		instrument.csound_code = code
		self.instruments.append(instrument)

	def get_instruments(self):
		return self.instruments