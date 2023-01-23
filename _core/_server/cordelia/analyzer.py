import re

from utils.constants import CORDELIA_SUBs, SCALA_HASPLAYED, GEN_HASPLAYED

#---inside send also GEN and SCALA if they're not already used
#unifier =  cordelia.Unifier()

def analyzer(unit) -> str():

	#check if the first line is commented - quicker way to mute instrument
	if not unit.startswith(';'):

		for category in CORDELIA_SUBs:

			match category:

				case 'note':
					for name in CORDELIA_SUBs[category]['list']:
						unit = re.sub(rf'(\W){name}(\d)(\#)(\W)', rf'\1"\2{name.upper()}\3"\4', unit, flags=re.MULTILINE)		
						unit = re.sub(rf'(\W){name}(\d)b(\W)', rf'\1"\2{name.upper()}b"\3', unit, flags=re.MULTILINE)		
						unit = re.sub(rf'(\W){name}(\d)(\W)', rf'\1"\2{name.upper()}"\3', unit, flags=re.MULTILINE)	

				case 'scala':
					for name in CORDELIA_SUBs[category]['list']:
						#keep track of scala tuning system
						if re.search(rf'(\W){name}(\W)', unit, flags=re.MULTILINE):
							if name not in SCALA_HASPLAYED:
								#send to csound
								SCALA_HASPLAYED.append(name)
							wildcard = str(CORDELIA_SUBs[category]['wildcard'])
							unit = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)

				case 'gen':
					for name in CORDELIA_SUBs[category]['list']:
						#keep track of scala tuning system
						if re.search(rf'(\W){name}(\W)', unit, flags=re.MULTILINE):
							if name not in GEN_HASPLAYED:
								#send to csound
								GEN_HASPLAYED.append(name)
							wildcard = str(CORDELIA_SUBs[category]['wildcard'])
							unit = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)

				case _:
					for name in CORDELIA_SUBs[category]['list']:
						wildcard = str(CORDELIA_SUBs[category]['wildcard'])
						unit = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)
	
	return unit
