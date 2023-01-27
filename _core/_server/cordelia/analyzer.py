import re
from csound import csound_cordelia

from utils.constants import CORDELIA_INSTR_json, CORDELIA_SCALA_json, CORDELIA_GEN_json
from utils.constants import CORDELIA_NOTEs, CORDELIA_MACROs
from utils.constants import SCALA_HASPLAYED, GEN_HASPLAYED, INSTR_HASPLAYED

#---inside send also GEN and SCALA if they're not already used
#unifier =  cordelia.Unifier()

def analyzer(unit) -> str():

	#check if the first line is commented - quicker way to mute instrument
	if not unit.startswith(';'):

		for name in CORDELIA_NOTEs:
			unit = re.sub(rf'(\W){name}(\d)(\#)(\W)', rf'\1"\2{name.upper()}\3"\4', unit, flags=re.MULTILINE)		
			unit = re.sub(rf'(\W){name}(\d)b(\W)', rf'\1"\2{name.upper()}b"\3', unit, flags=re.MULTILINE)		
			unit = re.sub(rf'(\W){name}(\d)(\W)', rf'\1"\2{name.upper()}"\3', unit, flags=re.MULTILINE)	

		for name in CORDELIA_MACROs:
			wildcard = '$'
			unit = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)
		
		if re.search(rf'scala-\w+', unit, flags=re.MULTILINE):
			for name in CORDELIA_SCALA_json:
				#keep track of scala tuning system
				if re.search(rf'(\W){name}(\W)', unit, flags=re.MULTILINE):
					if name not in SCALA_HASPLAYED:
						string = CORDELIA_SCALA_json[name]['ftgen']
						csound_cordelia.compileOrcAsync(string)
						SCALA_HASPLAYED.append(name)
					wildcard = 'gi'
					unit = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)

		for name in CORDELIA_GEN_json:
			#keep track of scala tuning system
			if re.search(rf'(\W){name}(\W)', unit, flags=re.MULTILINE):
				if name not in GEN_HASPLAYED:
					path = CORDELIA_GEN_json[name]
					csound_cordelia.compileOrcAsync(f'#include "{path}"')
					GEN_HASPLAYED.append(name)
				wildcard = 'gi'
				unit = re.sub(rf'(\W){name}(\W)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)
	
		for name in re.findall('@(\w+)', unit):
			if name not in INSTR_HASPLAYED:
				path = CORDELIA_INSTR_json[name]['path']
				#csound_cordelia.compileOrcAsync(f'#include "{path}"')
				with open(path) as f:
					csound_cordelia.compileOrcAsync(f.read())

				INSTR_HASPLAYED.append(name)
				#and create an array
				instr_setting = f'gS{name}[] init ginchnls\n'
				for each in range(csound_cordelia.nchnls()):
					instr_setting += f'gS{name}[{each}] sprintf	"{name}_%i", {each+1}\n'
					instr_setting += f'schedule {950 + ((each+1)/1000)}+({len(INSTR_HASPLAYED)-1}/10000), 0, -1, sprintf("{name}_%i", {each+1})\n'
				csound_cordelia.compileOrcAsync(instr_setting)

	return unit
