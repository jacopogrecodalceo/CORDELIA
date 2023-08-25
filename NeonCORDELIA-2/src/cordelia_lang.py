from src.lexer import Tokenizer
from src.parser.parser import Parser

def cordelia_input(input_code):
	tokenizer = Tokenizer(input_code)
	tokens = tokenizer.get_tokens()
	parser = Parser(tokens)
	parser.parse()
	instruments = parser.get_instruments()
	
	for i in instruments:
		i.log()
		print('-'*35)
