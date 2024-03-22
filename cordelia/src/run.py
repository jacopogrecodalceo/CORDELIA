
from constants.var import cordelia_init_code, cordelia_compile
from constants.var import memories

from src import init, lexer, parser, interpreter
#from utils.debug import line_profile_it

PRINT_MESSAGE = True

def handler_cordelia(code):

	init.cordelia_init(memories)

	code = init.convert(code)
	original_tokens = lexer.tokenize(code)
	tokens_no_comments = parser.parse_comments(original_tokens)
	verified_tokens = parser.verify(tokens_no_comments)
	grouped_tokens = parser.parse_by_group(verified_tokens)
	virgin_instruments = parser.parse(grouped_tokens)
	explicit_instruments = interpreter.explicit(virgin_instruments) # Explicit and make variables
	separated_instruments = interpreter.separate(explicit_instruments)
	init.compare_instruments_last(separated_instruments)

	instrument_res = []
	for index in range(len(cordelia_compile)):
		code = interpreter.wrap(index, cordelia_compile[index])
		if code:
			instrument_res.append(code)
			cordelia_compile[index] = None

	main_code = '\n'.join(cordelia_init_code + instrument_res) if cordelia_init_code else '\n'.join(instrument_res)

	if PRINT_MESSAGE:
		for j in (cordelia_init_code + instrument_res):
			print('.'*64)
			print(j)
			print('.'*64)
	cordelia_init_code.clear()
	
	return main_code

#@line_profile_it
def handler_reaper_1(code):

	init.cordelia_init(memories)

	code = init.convert(code)
	original_tokens = lexer.tokenize(code)
	tokens_no_comments = parser.parse_comments(original_tokens)
	verified_tokens = parser.verify(tokens_no_comments)
	grouped_tokens = parser.parse_by_group(verified_tokens)
	virgin_instruments = parser.parse(grouped_tokens)
	return virgin_instruments

def handler_reaper_2(virgin_instruments):
	cordelia_init_code.clear()
	explicit_instruments = interpreter.explicit(virgin_instruments) # Explicit and make variables
	separated_instruments = interpreter.separate(explicit_instruments)

	instrument_res = []
	init.add_to_compile(separated_instruments, instrument_res)

	for index in range(len(cordelia_compile)):
		code = interpreter.wrap(index, cordelia_compile[index])
		if code:
			instrument_res.append(code)
			cordelia_compile[index] = None
	
	return '\n'.join(instrument_res)
