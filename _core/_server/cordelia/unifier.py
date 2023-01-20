import re

from utils.constants import CORDELIA_SUBs, SCALA_HASPLAYED, GEN_HASPLAYED

#---receive code
#---return a list of each unity in the code
#---inside send also GEN and SCALA if they're not already used
#unifier =  cordelia.Unifier()

def unifier(code):

	#added for regex parse
	code += '\n'

	#delete all $ symbol for macros
	code = re.sub(r'\$', '', code, re.MULTILINE)

	pre_units = re.findall(r'^(.(?:\n|.)*?)\n$', code, re.MULTILINE)
	units = []

	for unit in pre_units:

		for category in CORDELIA_SUBs:

			match category:

				case 'note':
					for name in CORDELIA_SUBs[category]['list']:
						unit = re.sub(rf'(\W){name}(\d)(\#)(\W)', rf'\1"\2{name.upper()}\3"\4', unit, re.MULTILINE)		
						unit = re.sub(rf'(\W){name}(\d)b(\W)', rf'\1"\2{name.upper()}b"\3', unit, re.MULTILINE)		
						unit = re.sub(rf'(\W){name}(\d)(\W)', rf'\1"\2{name.upper()}"\3', unit, re.MULTILINE)	

				case 'scala':
					for name in CORDELIA_SUBs[category]['list']:
						#keep track of scala tuning system
						if re.search(rf'(\W){name}(\W)', unit, re.MULTILINE):
							if not name in SCALA_HASPLAYED:
								#send to csound
								SCALA_HASPLAYED.append(name)
							wildcard = str(CORDELIA_SUBs[category]['wildcard'])
							unit = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', unit, re.MULTILINE)

				case 'gen':
					for name in CORDELIA_SUBs[category]['list']:
						#keep track of scala tuning system
						if re.search(rf'(\W){name}(\W)', unit, re.MULTILINE):
							if not name in GEN_HASPLAYED:
								#send to csound
								GEN_HASPLAYED.append(name)
							wildcard = str(CORDELIA_SUBs[category]['wildcard'])
							unit = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', unit, re.MULTILINE)

				case _:
					for name in CORDELIA_SUBs[category]['list']:
						wildcard = str(CORDELIA_SUBs[category]['wildcard'])
						unit = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', unit, re.MULTILINE)

		units.append(unit)
	
	return units
