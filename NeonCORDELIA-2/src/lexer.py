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
			for token in cordelia_json['basic_token']:
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
		for name in cordelia_json[token_type]:
			regex = re.compile(rf'(?<=\W){name}(?=\W|$)')
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
				token.value = token.value.replace('scala.', '')
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

	def verify(self):

		verify_token = [
			'SCALA',
			'GEN',
			'ROUTING',
			'INSTR'
		]
		
		for i, token in enumerate(self.tokens):
			token_type = token.type
			value = token.value
			if token_type in verify_token and value not in cordelia_has:
				cordelia_has.append(value)
				file_json = cordelia_json[token_type]

				if value in file_json:
					print(f'📩{value} is verified.')

					if token_type == 'SCALA':
						cordelia_init_code.append(file_json[value]['ftgen'])
						self.tokens[i].value = 'gi' + value

					elif token_type == 'GEN':
						cordelia_init_code.append(file_json[value])
						self.tokens[i].value = 'gi' + value

					elif token_type == 'ROUTING':
						pass

					elif token_type == 'INSTR':
						pass

				else:
					raise ValueError(f'{token.type} with {token.value} is not found!')
		

	def get_tokens(self):

		for attr_name in dir(self):
			attr = getattr(self, attr_name)
			if callable(attr) and attr_name.startswith('tokenize_'):
				attr()
	
		self.tokens = sorted(self.tokens, key=lambda item: item[0])
		self.tokens = [token for (_, token) in self.tokens]
		
		self.ruler()
		self.verify()

		return self.tokens
