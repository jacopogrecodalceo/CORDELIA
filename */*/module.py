import re, json
import cordelia.opcodes
from utils.constants import cordelia_dir

opcodes_names = [f for f in dir(cordelia.opcodes) if not f.startswith('__') and not f == 're']

scala_hasplayed = []
gen_hasplayed = []
instr_hasplayed = []

#opcodes_dirpath = glob.glob('/Users/j/Documents/PROJECTs/CORDELIAv4/opcodes' + '/*.py')
#opcodes_names = [os.path.basename(f)[:-3] for f in opcodes_dirpath if os.path.isfile(f) and not f.endswith('__init__.py')]

sub_json_path = cordelia_dir + '/_list/subs.json'

#open json
with open(sub_json_path) as f:
	sub_json = json.load(f)


def separate_each_module(string):
	#######################################
	# SEPARATE EACH MODULE
	#######################################

	#prevent end of the line for regex
	string += '\n'

	#separate each module in a list
	list = re.findall(r"^(.(?:\n|.)*?)\n$", string, re.MULTILINE)

	return list



def first_parser(module):
	#######################################
	# FIRST PARSING
	#######################################

	#delete all $ symbol for macros
	module = re.sub(r'\$', '', module, re.MULTILINE)

	for cat in sub_json:
		match cat:
			case 'note':
				for name in sub_json[cat]['list']:
					module = re.sub(rf'(\W){name}(\d)(\#)', rf'\1"\2{name.upper()}\3"', module, re.MULTILINE)		
					module = re.sub(rf'(\W){name}(\d)b', rf'\1"\2{name.upper()}b"', module, re.MULTILINE)		
					module = re.sub(rf'(\W){name}(\d)', rf'\1"\2{name.upper()}"', module, re.MULTILINE)	
			case 'scala':
				for name in sub_json[cat]['list']:
					#keep track of scala tuning system
					if re.search(rf'(\W){name}(\W)', module, re.MULTILINE):
						if not name in scala_hasplayed:
							#send to csound
							scala_hasplayed.append(name)
						wildcard = str(sub_json[cat]['wildcard'])
						module = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', module, re.MULTILINE)
			case 'gen':
				for name in sub_json[cat]['list']:
					#keep track of scala tuning system
					if re.search(rf'(\W){name}(\W)', module, re.MULTILINE):
						if not name in gen_hasplayed:
							#send to csound
							gen_hasplayed.append(name)
						wildcard = str(sub_json[cat]['wildcard'])
						module = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', module, re.MULTILINE)
			case _:
				for name in sub_json[cat]['list']:
					wildcard = str(sub_json[cat]['wildcard'])
					module = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', module, re.MULTILINE)

	return module


def index_lines(module):

	#module is a string!

	#remove tabs
	module = re.sub(r'[\t]*', '', module)

	#each line is separated in a list
	module_lines = module.splitlines()

	#create 2 list
	params_lines = []
	addendum_lines = []

	#check if the first line is commented (quicker way to mute instrument)
	if not module_lines[0].startswith(';'):

		#if not create a index line sensible list
		for line in module_lines:
			#ignoring comment
			if not line.startswith(';'):
				if not line.startswith('+'):
					params_lines.append(line)
				else:
					line = re.sub(r'^\+', '', line)
					addendum_lines.append(line)

	#######################################
	# FIND PARAMs
	#######################################

	#if the first line is an opcodes
	if params_lines[0].split(':')[0] in opcodes_names:
		#this is a list of dict
		dict_list = cordelia.opcodes.eu(params_lines)

		#######################################
		# ADD ADDENDUM TO DICT
		#######################################
		if addendum_lines:
			for each in dict_list:
				each.update({'addendum': addendum_lines})

		#######################################
		# CHECK IF PLAYED
		#######################################

		for each in dict_list:
			if not each['instr']['name'] in instr_hasplayed:
				#send to csound
				instr_hasplayed.append(each['instr']['name'])

		#######################################
		# APPEND TO RESULT LIST
		#######################################

	#flat the output
	#return [item for sublist in dict_list for item in sublist]
	return dict_list


def convert_dict(string):

	modules = separate_each_module(string)
	res = []

	for module in modules:
		if len(module.splitlines()) == 1:
			#is a command
			score = first_parser(module)
			res.append(score)
		else:	
			#is an opcode
			score = first_parser(module)
			score_list = index_lines(score)
			
			for each in score_list:
				res.append(each)

	return res