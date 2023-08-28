from src.a_lexer import Lexer
from src.b_parser import Parser
from src.c_interpreter import *

from constants.var import cordelia_compile

def handle_input(code):

	lexer = Lexer(code)
	tokens = lexer.tokenize()

	parser = Parser(tokens)
	instruments = parser.get_instruments()
	
	cordelia_init()
	compare_instruments_last(instruments)
	for i in cordelia_compile:
		if i.status == 'alive':
			print(i.code)
			
	cordelia_compile.clear()
