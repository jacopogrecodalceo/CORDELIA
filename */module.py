import re
import json

import opcode



opcode_names = [f for f in dir(opcode) if not f.startswith('__') and not f == 're']

#opcode_dirpath = glob.glob('/Users/j/Documents/PROJECTs/CORDELIAv4/opcode' + '/*.py')
#opcode_names = [os.path.basename(f)[:-3] for f in opcode_dirpath if os.path.isfile(f) and not f.endswith('__init__.py')]

module = '''eu: "10", 2
	+Snote = g4b
	;comment
	r4@orphans4@maybe.flingj(123, lfh(2)).getmeout(2.2, 123, asd())
	beats*32
	;dioporco
	pp
	classic
	cpstun(random:k(1, 2), once(), ntom(Snote)+2, vitry)
	cpstun(random:k(1, 2), ntom(f7#)+2, vitry)
	cpstun(random:k(1, 2), ntom(e4)+2, vitry)
	cpstun(random:k(1, 2), ntom(Snote)+2, edo12)
'''

scala_isplayed = []
gen_isplayed = []
instr_isplayed = []

#is_command
#is_opcode

#######################################
# LIST SUB
#######################################

sub_json_path = '/Users/j/Documents/PROJECTs/CORDELIAv4/_list/subs.json'

#open json
with open(sub_json_path) as f:
	sub_json = json.load(f)

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
					if not name in scala_isplayed:
						#send to csound
						scala_isplayed.append(name)
					wildcard = str(sub_json[cat]['wildcard'])
					module = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', module, re.MULTILINE)
		case 'gen':
			for name in sub_json[cat]['list']:
				#keep track of scala tuning system
				if re.search(rf'(\W){name}(\W)', module, re.MULTILINE):
					if not name in gen_isplayed:
						#send to csound
						gen_isplayed.append(name)
					wildcard = str(sub_json[cat]['wildcard'])
					module = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', module, re.MULTILINE)
		case _:
			for name in sub_json[cat]['list']:
				wildcard = str(sub_json[cat]['wildcard'])
				module = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', module, re.MULTILINE)

#######################################
# MODULE
#######################################

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
				addendum_lines.append(line)

#######################################
# FIND PARAMs
#######################################

#if the first line is an opcode
if params_lines[0].split(':')[0] in opcode_names:
	dict_module = opcode.eu(params_lines)

#######################################
# CHECK IF PLAYED
#######################################

for each in dict_module:
	if not each['instr']['name'] in instr_isplayed:
		#send to csound
		instr_isplayed.append(name)
