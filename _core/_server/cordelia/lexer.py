import pprint
import re
from os.path import dirname, basename, isfile, join
import glob

from utils.constants import *
import cordelia.opcodes

#---receive a list of unity
#---return a list of tokens for each unity
#lexer = cordelia.Lexer()

modules = glob.glob(join(dirname(__file__), 'opcodes', '*.py'))
opcode_names = [ basename(f)[:-3] for f in modules if isfile(f) and not f.endswith('__init__.py')]

def lexer(units):

	tokens = []

	for unit in units:

		#remove tabs
		unit = re.sub(r'[\t]*', '', unit)

		#each line is separated in a list
		unit_lines = unit.splitlines()

		#create 2 list
		params_lines = []
		addendum_lines_inside = []
		addendum_lines_outside = []

		#check if the first line is commented - quicker way to mute instrument
		if not unit_lines[0].startswith(';'):
			if re.search(r'^\w+', unit_lines[0])[0] not in opcode_names and len(unit_lines) == 1:
				tokens.append({'command': unit_lines[0]})

			elif re.search(r'^\w+', unit_lines[0])[0] in opcode_names and len(unit_lines) != 1:

				#create a index line sensible list
				for line in unit_lines:
					
					#######################################
					# PARSE BY LINE
					#######################################

					#ignoring comment
					if not line.startswith(';'):
						#parse for addendum
						if line.startswith('+'):
							line = re.sub(r'^\+', '', line)
							addendum_lines_inside.append(line)
						elif line.startswith('-'):
							line = re.sub(r'^-', '', line)
							addendum_lines_outside.append(line)						
						else:
							params_lines.append(line)


				pretokens = []
				#opcode_func return a list - if there's 2named instrs
				opcode_func = getattr(cordelia.opcodes, params_lines[0].split(':')[0])
				pretokens = opcode_func(params_lines)

				#######################################
				# ADD ADDENDUM TO DICT
				#######################################

				for each in pretokens:
					
					if addendum_lines_inside:
						each['instr'].update({'addendum_inside': addendum_lines_inside})
					else:
						each['instr'].update({'addendum_inside': ''})
					
					if addendum_lines_outside:
						each['instr'].update({'addendum_outside': addendum_lines_outside})
					else:
						each['instr'].update({'addendum_outside': ''})

					tokens.append(each)

					#extract route
					string = 'route'
					if string in each:
						tokens.append({string: each[string]})
						each.pop(string)

			else:
				print(f'{bcolors.WARNING}WARNING{bcolors.ENDC}: this line {bcolors.WARNING}{unit_lines}{bcolors.ENDC} has a problem!')
		
	return tokens