import re
from csound import csound_cordelia

from utils.constants import CORDELIA_REPLACE_json, CORDELIA_INSTR_json, CORDELIA_SCALA_json, CORDELIA_GEN_json
from utils.constants import SCALA_HASPLAYED, GEN_HASPLAYED, INSTR_HASPLAYED

#---inside send also GEN and SCALA if they're not already used
#unifier =  cordelia.Unifier()

def analyzer(unit) -> str():

	#check if the first line is commented - quicker way to mute instrument
	if not unit.startswith(';'):

		for category in CORDELIA_REPLACE_json:

			match category:

				case 'note':
					for name in CORDELIA_REPLACE_json[category]['list']:
						unit = re.sub(rf'(\W){name}(\d)(\#)(\W)', rf'\1"\2{name.upper()}\3"\4', unit, flags=re.MULTILINE)		
						unit = re.sub(rf'(\W){name}(\d)b(\W)', rf'\1"\2{name.upper()}b"\3', unit, flags=re.MULTILINE)		
						unit = re.sub(rf'(\W){name}(\d)(\W)', rf'\1"\2{name.upper()}"\3', unit, flags=re.MULTILINE)	

				case _:
					for name in CORDELIA_REPLACE_json[category]['list']:
						wildcard = str(CORDELIA_REPLACE_json[category]['wildcard'])
						unit = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)
		
		for name in CORDELIA_SCALA_json:
			#keep track of scala tuning system
			if re.search(rf'(\W){name}(\W)', unit, flags=re.MULTILINE):
				if name not in SCALA_HASPLAYED:
					string = CORDELIA_SCALA_json[name]['ftgen']
					csound_cordelia.compileOrc(string)
					SCALA_HASPLAYED.append(name)
				wildcard = 'gi'
				unit = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)

		for name in CORDELIA_GEN_json:
			#keep track of scala tuning system
			if re.search(rf'(\W){name}(\W)', unit, flags=re.MULTILINE):
				if name not in GEN_HASPLAYED:
					path = CORDELIA_GEN_json[name]
					csound_cordelia.compileOrc(f'#include "{path}"')
					GEN_HASPLAYED.append(name)
				wildcard = 'gi'
				unit = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)
	
		for name in CORDELIA_INSTR_json:
			if re.search(rf'(\W){name}(\W)', unit, flags=re.MULTILINE):
				if name not in INSTR_HASPLAYED:
					path = CORDELIA_INSTR_json[name]['path']
					csound_cordelia.compileOrc(f'#include "{path}"')
					INSTR_HASPLAYED.append(name)
					#and create an array
					instr_setting = f'''
					gS{name}[] init ginchnls

					indx	init 0
					until	indx == ginchnls do
						gS{name}[indx] sprintf	"{name}_%i", indx+1
						schedule 950+((indx+1)/1000)+({len(INSTR_HASPLAYED)-1}/10000), 0, -1, sprintf("{name}_%i", indx+1)
						indx += 1
					od
					'''
					csound_cordelia.compileOrc(instr_setting)
					print(instr_setting)

	return unit
