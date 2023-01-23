import pprint
import re
from os.path import dirname, basename, isfile, join
import glob

from utils.constants import *

import cordelia
import cordelia.opcodes


#---receive a list of unity
#---return a list of tokens for each unity
#lexer = cordelia.Lexer()

modules = glob.glob(join(dirname(__file__), 'opcodes', '*.py'))
opcode_names = [ basename(f)[:-3] for f in modules if isfile(f) and not f.endswith('__init__.py')]



def lexer(unit) -> list():

	#remove tabs
	unit = re.sub(r'[\t]*', '', unit)

	#each line is separated in a list
	unit_lines = unit.splitlines()

	if re.search(r'^\w+', unit_lines[0])[0] not in opcode_names and len(unit_lines) == 1:
		instrument = cordelia.Instrument(unit_lines[0])

	elif re.search(r'^\w+', unit_lines[0])[0] in opcode_names and len(unit_lines) != 1:

		opcode_function = getattr(cordelia.opcodes, unit_lines[0].split(':')[0])
		instrument = opcode_function(unit_lines)

	else:
		print(f'{bcolors.WARNING}WARNING{bcolors.ENDC}: this line {bcolors.WARNING}{unit_lines}{bcolors.ENDC} has a problem!')

	print(instrument)	

	return instrument