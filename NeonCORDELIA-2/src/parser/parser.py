import pprint

from src.lexer import Tokenizer
from src.dropper import drop_to_csound

def condition(condition_data):
	def decorator(func):
		func.condition_data = condition_data
		return func
	return decorator

class Parser:

	def __init__(self, input_code):

		tokenizer = Tokenizer(input_code)
		tokens = tokenizer.get_tokens()
		self.tokens = drop_to_csound(tokens)

		for attr_name in dir(self):
			attr = getattr(self, attr_name)
			if callable(attr) and attr_name.startswith('tidy_'):
				attr()
		
		self.parse_func = []
		for attr_name in dir(self):
			if attr_name.startswith('parse_'):
				self.parse_func.append(attr_name)

		self.conditions = self.gather_conditions()

	def gather_conditions(self):
			conditions = {}
			methods = [getattr(self, method) for method in dir(self) if callable(getattr(self, method)) and method.startswith('parse_')]
			for method in methods:
				method_name = method.__name__
				if hasattr(method, 'condition_data'):
					conditions[method_name] = method.condition_data
			return conditions

	def print_tokens(self):
		for token in self.tokens:
			if token.type != 'NEWLINE' and token.type != 'EMPTYLINE':
				print(token.type, '   \t', '.'*30, token.value)
			else:
				print(token.type)

	def print_nodes(self, nodes):
		for node in nodes:
			print('-'*50)
			for token in node:
				print(''.join(token.value))

	# ============
	# TIDY SECTION
	# ============
	def tidy_newline(self):
		for i, token in enumerate(self.tokens):
			if token.type == 'NEWLINE' and self.tokens[i - 1].type == 'NEWLINE':
				token.type = 'EMPTYLINE'
				self.tokens.pop(i - 1)

	def tidy_scala(self):
		# Remove 'scala.' from scalas
		for i, token in enumerate(self.tokens):
			if token.type == 'SCALA':
				token.value = 'gi' + token.value
				self.tokens.pop(i - 1)
				self.tokens.pop(i - 2)

	def tidy_instr(self):
		# Remove '@' from instruments
		for i, token in enumerate(self.tokens):
			if token.type == 'INSTR':
				self.tokens.pop(i - 1)

	# ============
	# MAIN PARSE FUNC
	# ============
	def parse(self):

		while self.tokens:
			token = self.tokens.pop(0)

			for condition_func, condition in self.conditions.items():
				selected_tokens = []
				if token.type == condition['start']:
					selected_tokens.append(token)

					while self.tokens and self.tokens[0].type not in condition['end']:
						selected_tokens.append(self.tokens.pop(0))

					func = getattr(self, condition_func)
					func(selected_tokens)
					break

	@condition({'start': 'COMMENT', 'end': 'EMPTYLINE'})
	def parse_comment(self, tokens):
		for token in tokens:
			print(token.value)

	@condition({'start': 'RHYTHM', 'end': 'EMPTYLINE'})
	def parse_rhythmic_seq(self, tokens):
		for token in tokens:
			print(token.value)

	@condition({'start': 'INSTR', 'end': ['EMPTYLINE', 'NEWLINE']})
	def parse_sonvs_seq(self, tokens):
		for token in tokens:
			print(token.value)
	
	@condition({'start': 'VALUE', 'end': ['EMPTYLINE', 'NEWLINE']})
	def parse_csound_command(self, tokens):
		for token in tokens:
			print(token.value)
