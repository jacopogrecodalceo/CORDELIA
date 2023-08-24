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
		code = self.code
		pos = 0
		# Tokenize basic
		while code:
			#print(self.code)
			match = None
			for token in cordelia_basic_token_json:
				regex = re.compile(token['pattern'])
				match = regex.match(code)
				if match:
					value = match.group()
					pos += match.end()
					self.tokens.append((pos, Token(token['type'], value)))
					code = code[match.end():]
					break

			if not match:
				# If no match, skip character
				code = code[1:]
				pos += 1

	def tokenize_gen(self):
		token_type = 'GEN'
		for name in cordelia_gen_json:
			regex = re.compile(f'(?<=\W){name}(?=\W|$)')
			matches = regex.finditer(self.code)
			for match in matches:
				value = match.group(0).strip()
				position = match.start()
				self.tokens.append((position, Token(token_type, value)))
		
				for i, (_, token) in enumerate(self.tokens):
					if token.value == value and token.type == 'VALUE':
						self.tokens.pop(i)

	
	def ruler(self):

		for i, token in enumerate(self.tokens):
			if token.type == 'SCALA':
				# Remove 'scala.'
				token.value = token.value.replace('scala.', 'gi')	
			elif token.type == 'INSTR':
				# Remove '@'
				token.value = token.value[1:]
			elif token.type == 'RHYTHM':
				# Remove ':'
				token.value = token.value[:-1]
			elif token.type == 'ROUTING':
				# Remove the '.'
				token.value = token.value[1:]
			elif token.type == 'NEWLINE' and i < len(self.tokens)-1 and self.tokens[i + 1].type == 'NEWLINE' :
				token.type = 'EMPTYLINE'

	def get_tokens(self):

		for attr_name in dir(self):
			attr = getattr(self, attr_name)
			if callable(attr) and attr_name.startswith('tokenize_'):
				attr()
	
		self.tokens = sorted(self.tokens, key=lambda item: item[0])
		self.tokens = [token for (_, token) in self.tokens]
		self.ruler()
	
		return self.tokens
