from src.a_lexer import Lexer
from src.b_parser import Parser
from src.c_interpreter import *

from constants.var import cordelia_init_code, cordelia_compile
from constants.var import memories

def handle_input_cordelia(code):
	cordelia_init(memories)

	code = init_conversion(code)

	lexer = Lexer(code)
	tokens = lexer.tokenize()

	parser = Parser(tokens)
	instruments = parser.get_instruments()
	
	compare_instruments_last(instruments)

	instrument_res = []
	for index in range(len(cordelia_compile)):
		code = wrapper(index, cordelia_compile[index])
		if code:
			instrument_res.append(code)
			cordelia_compile[index] = None
	
	main_code = '\n'.join(cordelia_init_code + instrument_res) if cordelia_init_code else '\n'.join(instrument_res)
	print('\n---\n'.join(cordelia_init_code + instrument_res))
	cordelia_init_code.clear()
	return main_code

def handle_input_reaper(code):
	memories = False
	cordelia_init(memories)

	code = init_conversion(code)

	lexer = Lexer(code)
	tokens = lexer.tokenize()

	parser = Parser(tokens)
	instruments = parser.get_instruments()
	
	compare_instruments_last(instruments)

	instrument_res = []
	for index in range(len(cordelia_compile)):
		code = wrapper(index, cordelia_compile[index])
		if code:
			instrument_res.append(code)
			cordelia_compile[index] = None
	
	main_code = '\n'.join(cordelia_init_code + instrument_res) if cordelia_init_code else '\n'.join(instrument_res)
	print('\n---\n'.join(cordelia_init_code + instrument_res))
	cordelia_init_code.clear()
	return main_code
