import re

from constants.var import cordelia_json

class Token:
	def __init__(self, type, value):
		self.type = type
		self.value = value

def tokenize(code):
	tokens = []
	# Tokenize basic
	while code:
		match = None
		for token in cordelia_json['tokens']:
			regex = re.compile(token['pattern'], re.MULTILINE)
			#regex = re.compile(token['pattern'])
			match = regex.match(code)
			if match:
				value = match.group()
				tokens.append(Token(token['type'], value))
				code = code[match.end():]
				break

		if not match:
			# If no match, skip character
			code = code[1:]
	
	return tokens

def print_tokens(tokens):
	print('-'*40)
	for token in tokens:
		if token.type != 'NEWLINE' and token.type != 'EMPTYLINE':
			print(token.type, '   \t', '.'*30, token.value)
		else:
			print(token.type, '   \t', '.'*30, token.type)
	print('-'*40)

def print_token(token):
	if token.type != 'NEWLINE' and token.type != 'EMPTYLINE':
		print(token.type, '   \t', '.'*30, token.value)
	else:
		print(token.type, '   \t', '.'*30, token.type)