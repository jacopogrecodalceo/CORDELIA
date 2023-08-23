import re

from constants.var import *

# Token class to store token information
class Token:
	def __init__(self, type, value):
		self.type = type
		self.value = value

class Tokenizer:
	def __init__(self, code):
		self.code = code

		self.tokens = []

	def tokenize_basic(self):

		# Tokenize basic
		for token in cordelia_basic_token_json:
			regex = re.compile(token['pattern'])
			matches = regex.finditer(self.code)
			for match in matches:
				position = match.start()
				self.tokens.append((position, Token(token['type'], match.group(0))))
		
		# Tokenize everything else with 'SYMBOL'
		token_type = 'SYMBOL'
		combined_pattern = '\s+|' # add also spaces
		combined_pattern += "|".join(pattern['pattern'] for pattern in cordelia_basic_token_json)
		# Compile the combined pattern into a regex object
		combined_regex = re.compile(f"(?!{combined_pattern}).")

		# Find all matches using the combined regex
		matches = combined_regex.finditer(self.code)
		for match in matches:
			position = match.start()
			self.tokens.append((position, Token(token_type, match.group(0))))

	def tokenize_instr(self):
		token_type = 'INSTR'
		regex = re.compile(r'@(\w+)')
		matches = regex.finditer(self.code)
		for match in matches:
			name = match.group(1).strip()
			if name in cordelia_instr_json:
				position = match.start(1)
				self.tokens.append((position, Token(token_type, name)))

	def tokenize_gen(self):
		token_type = 'GEN'
		for name in cordelia_gen_json:
			regex = re.compile(f'(?<=\W){name}(?=\W|$)')
			matches = regex.finditer(self.code)
			for match in matches:
				position = match.start()
				self.tokens.append((position, Token(token_type, match.group(0).strip())))

	def tokenize_rounting(self):
		token_type = 'ROUTING'
		regex = re.compile(r'\.(\w+)')
		matches = regex.finditer(self.code)
		for match in matches:
			name = match.group(1).strip()
			if name in cordelia_routing_json:
				position = match.start(1)
				self.tokens.append((position, Token(token_type, name)))

	def tokenize_scala(self):
		token_type = 'SCALA'
		index = 2
		regex = re.compile(r'(scala\.)(\w+)')
		matches = regex.finditer(self.code)
		for match in matches:
			name = match.group(index).strip()
			if name in cordelia_scala_json:
				position = match.start(index)
				self.tokens.append((position, Token(token_type, name)))				

	def tokenize_rhythm(self):
		token_type = 'RHYTHM'
		keys = ['eu']
		for name in keys:
			regex = re.compile(f'(?<=\W){name}(?=\W|$)')
			matches = regex.finditer(self.code)
			for match in matches:
				position = match.start()
				self.tokens.append((position, Token(token_type, match.group(0).strip())))

	def get_tokens(self):

		for attr_name in dir(self):
			attr = getattr(self, attr_name)
			if callable(attr) and attr_name.startswith('tokenize_'):
				attr()
		
		self.tokens = sorted(self.tokens, key=lambda item: item[0])

		unique_tokens = []

		for i, (_, token) in enumerate(self.tokens):
			if token.type == 'VALUE':
				if i == 0 or i == len(self.tokens) - 1:
					unique_tokens.append(token)
				elif token.value != self.tokens[i - 1][1].value and token.value != self.tokens[i + 1][1].value:
					unique_tokens.append(token)
			else:
				unique_tokens.append(token)

		return unique_tokens
