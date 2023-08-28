from src.a_lexer import Lexer
from src.b_parser import Parser
from src.c_interpreter import *

from constants.var import cordelia_init_code, cordelia_compile

def handle_input(code):
	cordelia_init()

	lexer = Lexer(code)
	tokens = lexer.tokenize()

	parser = Parser(tokens)
	instruments = parser.get_instruments()
	
	compare_instruments_last(instruments)

	res = []
	for index in range(len(cordelia_compile)):
		code = wrapper(index, cordelia_compile[index])
		if code:
			res.append(code)
			cordelia_compile[index] = None
	
	main_code = '\n'.join(cordelia_init_code + res) if cordelia_init_code else '\n'.join(res)
	cordelia_init_code.clear()
	print('\n---\n'.join(cordelia_init_code + res))
	return main_code


