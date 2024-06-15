import re

from constants.var import *

# Token class to store token information
class Token:
	def __init__(self, type, value):
		self.type = type
		self.value = value

class Lexer:
	def __init__(self, code):
		self.code = code
		self.tokens = []

	def tokenize(self):
		pos = 0
		# Tokenize basic
		while self.code:
			match = None
			for token in cordelia_json['tokens']:
				regex = re.compile(token['pattern'], re.MULTILINE)
				match = regex.match(self.code)
				if match:
					value = match.group()
					pos += match.end()
					self.tokens.append(Token(token['type'], value))
					self.code = self.code[match.end():]
					break

			if not match:
				# If no match, skip character
				self.code = self.code[1:]
				pos += 1
		
		return self.tokens
