import pprint
import re
from os.path import dirname, basename, isfile, join
from glob import glob

from utils.constants import bcolors

import cordelia
import cordelia.opcodes

#---receive a list of unity
#---return a list of tokens for each unity
#lexer = cordelia.Lexer()

modules = glob(join(dirname(__file__), 'opcodes', '*.py'))
opcode_names = [ basename(f)[:-3] for f in modules if isfile(f) and not f.endswith('__init__.py')]

def lexer(unit) -> list():

	#remove tabs
	unit = re.sub(r'[\t]*', '', unit)

	#each line is separated in a list
	unit_lines = unit.splitlines()

	try:

		if len(unit_lines) == 1:

			if re.search(r'^@', unit_lines[0]):
				pre_instrument = cordelia.opcodes.sonvs(unit_lines[0])
				print(pre_instrument)
				return pre_instrument

			else:
				pre_instrument = cordelia.Instrument([unit_lines[0]])
				return pre_instrument
					
		else:

			opcode_match = re.search(r'^\w+', unit_lines[0])[0]

			if opcode_match in opcode_names:
				opcode_function = getattr(cordelia.opcodes, unit_lines[0].split(':')[0])
				pre_instrument = opcode_function(unit_lines)
				return pre_instrument

			else:
				print(f'{bcolors.WARNING}WARNING{bcolors.ENDC}: your code has an unknown opcode {unit_lines}{bcolors.ENDC}')

	
	except Exception as e:
		print(f'{bcolors.WARNING}WARNING{bcolors.ENDC}: these lines {bcolors.WARNING}{unit_lines}{bcolors.ENDC} have a problem!')
		print(e)

