import re

from utils.constants import CORDELIA_NOTEs
def note(unit):
	for name in CORDELIA_NOTEs:
		unit = re.sub(rf'(\W){name}(\d)(\W|$)', rf'\1"\2{(name[0].upper() + name[1]) if len(name) > 1 else name[0].upper()}"\3', unit, flags=re.MULTILINE)		
	return unit

from utils.constants import CORDELIA_MACROs
def macro(unit):
	for name in CORDELIA_MACROs:
		wildcard = '$'
		unit = re.sub(rf'(\W){name}(\W|$)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)
	return unit

from utils.constants import CORDELIA_ABBR_json
def abbr(unit):
	for name, repl in CORDELIA_ABBR_json.items():
		unit = re.sub(rf'(\W){name}(\W|$)', rf'\1{repl}\2', unit, flags=re.MULTILINE)
		#unit = unit.replace(name, repl)
	return unit

from utils.constants import SCALA_HASPLAYED, CORDELIA_SCALA_json, CORDELIA_COMPILE
def scala(unit):
	if re.search(rf'scala\.\w+', unit, flags=re.MULTILINE):
					names = re.findall(rf'scala\.(\w+)', unit, flags=re.MULTILINE)
					for name in names:
						if name not in SCALA_HASPLAYED and name != 'edo12':
							string = CORDELIA_SCALA_json[name]['ftgen']
							#csound_cordelia.compileOrcAsync(string)
							CORDELIA_COMPILE.append(string)
							print(f'SEND---{name}')
							SCALA_HASPLAYED.append(name)
						wildcard = 'gi'
						#unit = re.sub(rf'(\W)scala-{name}(\W)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)
						unit = unit.replace(f'scala.{name}', f'{wildcard}{name}')
						#print(f'scala.{name}')
	return unit

from utils.constants import GEN_HASPLAYED, CORDELIA_GEN_json, CORDELIA_COMPILE
def gen(unit):
	for name in CORDELIA_GEN_json:
		#keep track of scala tuning system
		if re.search(rf'(\W){name}(\W|$)', unit, flags=re.MULTILINE):
			if name not in GEN_HASPLAYED:
				path = CORDELIA_GEN_json[name]
				with open(path) as f:
					string = f.read()
					CORDELIA_COMPILE.append(string)
					print(f'SEND {name}')
				GEN_HASPLAYED.append(name)
			
			has_atk = re.search(rf'{name}.a', unit, flags=re.MULTILINE)
			if has_atk:
				unit = unit.replace(f'{name}.a', f'{name}$atk')

			wildcard = 'gi'
			unit = re.sub(rf'(\W){name}(\W|$)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)
	return unit

from utils.constants import INSTR_HASPLAYED, CORDELIA_INSTR_json, CORDELIA_COMPILE
from csound import CORDELIA_NCHNLS
from utils.constants import DEFAULT_SONVS_PATH
def instr(unit):
	for name in re.findall('@(\w+)', unit):
					if name not in INSTR_HASPLAYED:
						path = CORDELIA_INSTR_json[name]['path']
						type = CORDELIA_INSTR_json[name]['type']

						if type == 'instr':
							with open(path) as f:
								#csound_cordelia.compileOrcAsync(f.read())
								string = f.read()
								CORDELIA_COMPILE.append(string)

						if type == 'sonvs':

							channels = CORDELIA_INSTR_json[name]['channels']
							path = CORDELIA_INSTR_json[name]['path']

							with open(DEFAULT_SONVS_PATH) as f:

								string = f'gS{name}_file init "{path}"' + '\n'
								string += f'gi{name}_ch init {channels}' + '\n'

								for i in range(int(channels)):
									ch = str(i + 1)
									string += f'gi{name}_{ch} ftgen 0, 0, 0, 1, gS{name}_file, 0, 0, {ch}' + '\n'
									
								string += re.sub(r'---NAME---', name, f.read(), flags=re.MULTILINE)
								CORDELIA_COMPILE.append(string)

						INSTR_HASPLAYED.append(name)
						#and create an array
						instr_setting = f'gS{name}[] init ginchnls\n'
						for each in range(CORDELIA_NCHNLS):
							instr_setting += f'gS{name}[{each}] sprintf	"{name}_%i", {each+1}\n'
							instr_num = 950 + ((each+1)/1000) + ((len(INSTR_HASPLAYED)-1)/10000)
							instr_setting += f'schedule {round(instr_num, 5)}, 0, -1, "{name}_{each+1}"\n'
						#csound_cordelia.compileOrcAsync(instr_setting)
						CORDELIA_COMPILE.append(instr_setting)
						print(f'SEND {name}')
						#print(instr_setting)
	return unit
