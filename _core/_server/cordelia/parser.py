import re

from cordelia.classes import Parser
from utils.constants import bcolors

from utils.constants import CORDELIA_NOTEs, CORDELIA_FOUT_MEMORIES
from utils.constants import CORDELIA_COMPILE_FIRST
from utils.constants import SCALA_HASPLAYED, CORDELIA_SCALA_json
from utils.constants import GEN_HASPLAYED, CORDELIA_GEN_json
from utils.constants import INSTR_HASPLAYED, CORDELIA_INSTR_json
from csound import CORDELIA_NCHNLS
from utils.constants import CORDELIA_CURRENT_DIR, CORDELIA_DATE
from utils.constants import CORDELIA_SF_json
from utils.constants import DEFAULT_SONVS_PATH, DEFAULT_SONVS_SAMP_PATH, DEFAULT_SONVS_SYNC_PATH, DEFAULT_SONVS_LPC_PATH, DEFAULT_SONVS_CONV_PATH

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
	for name, repl in CORDELIA_ABBR_json['single_words'].items():
		unit = re.sub(rf'(\W){name}(\W|$)', rf'\1{repl}\2', unit, flags=re.MULTILINE)
		#unit = unit.replace(name, repl)
	for name, repl in CORDELIA_ABBR_json['complex_words'].items():
		unit = re.sub(rf'{name}', rf'{repl}', unit, flags=re.MULTILINE)
		#unit = unit.replace(name, repl)
	return unit

def scala(unit):
	if re.search(r'scala\.\w+', unit, flags=re.MULTILINE):
					names = re.findall(r'scala\.(\w+)', unit, flags=re.MULTILINE)
					for name in names:
						if name not in SCALA_HASPLAYED and name != 'edo12':
							string = CORDELIA_SCALA_json[name]['ftgen']
							#csound_cordelia.compileOrcAsync(string)
							CORDELIA_COMPILE_FIRST.append(string)
							print(f'SEND {name}')
							SCALA_HASPLAYED.append(name)
						wildcard = 'gi'
						#unit = re.sub(rf'(\W)scala-{name}(\W)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)
						unit = unit.replace(f'scala.{name}', f'{wildcard}{name}')
						#print(f'scala.{name}')
	return unit

def gen(unit):
	for name in CORDELIA_GEN_json:
		#keep track of scala tuning system
		if re.search(rf'(\W){name}(\W|$)', unit, flags=re.MULTILINE):
			if name not in GEN_HASPLAYED:
				path = CORDELIA_GEN_json[name]
				with open(path) as f:
					string = f.read()
					#csound_cordelia.compileOrcAsync(string)
					CORDELIA_COMPILE_FIRST.append(string)
					print(f'SEND {name}')
				GEN_HASPLAYED.append(name)
			
			has_atk = re.search(rf'{name}.a', unit, flags=re.MULTILINE)
			if has_atk:
				unit = unit.replace(f'{name}.a', f'{name}$atk')

			wildcard = 'gi'
			unit = re.sub(rf'(\W){name}(\W|$)', rf'\1{wildcard}{name}\2', unit, flags=re.MULTILINE)
	return unit



def instr(unit):

	names = re.findall('@(\w+)', unit)
	queue_hybrid = []

	for name in names:
		if name not in INSTR_HASPLAYED:

			if name in CORDELIA_INSTR_json or name.startswith('sf_'):

				if name.startswith('sf_'):
					if name in CORDELIA_SF_json:
						CORDELIA_COMPILE_FIRST.append(CORDELIA_SF_json[name]['csound'])
				else:
					path = CORDELIA_INSTR_json[name]['path']
					type = CORDELIA_INSTR_json[name]['type']

					if type == 'instr':
						with open(path) as f:
							#csound_cordelia.compileOrcAsync(f.read())
							string = f.read()
							CORDELIA_COMPILE_FIRST.append(string)

					elif type == 'sonvs':

						channels = CORDELIA_INSTR_json[name]['channels']
						string = f'gi{name}_ch init {channels}' + '\n'
						index_num = 1
						file_vars = []
						vir = ', '

						if '_so' in name:
							with open(DEFAULT_SONVS_SAMP_PATH) as f:
								for index, p in enumerate(path):
									index_file = index + 1
									string += f'\ngS{name}_file_{index_file} init "{p}"' + '\n'
									for i in range(int(channels)):
										ch = str(i + 1)
										num = str(index_num)
										file_var = f'gi{name}_{num}'
										file_vars.append(file_var)
										string += f'{file_var} ftgen 0, 0, 0, 1, gS{name}_file_{index_file}, 0, 0, {ch}' + '\n'
										index_num += 1
								
								string += '\n'
								string += f'gi{name}_list[] fillarray {vir.join(file_vars)}\n'
								string += re.sub(r'---NAME---', name, f.read(), flags=re.MULTILINE)	
								string = re.sub(r'---PITCH---', str(CORDELIA_INSTR_json[name]['pitch']), string, flags=re.MULTILINE)

						elif '_sy' in name:
							with open(DEFAULT_SONVS_SYNC_PATH) as f:
								for index, p in enumerate(path):
									index_file = index + 1
									string += f'\ngS{name}_file_{index_file} init "{p}"' + '\n'
									for i in range(int(channels)):
										ch = str(i + 1)
										num = str(index_num)
										file_var = f'gi{name}_{num}'
										file_vars.append(file_var)
										string += f'{file_var} ftgen 0, 0, 0, 1, gS{name}_file_{index_file}, 0, 0, {ch}' + '\n'
										index_num += 1
								
								string += '\n'
								string += f'gi{name}_list[] fillarray {vir.join(file_vars)}\n'
								string += re.sub(r'---NAME---', name, f.read(), flags=re.MULTILINE)	
								string = re.sub(r'---PITCH---', str(CORDELIA_INSTR_json[name]['pitch']), string, flags=re.MULTILINE)

						elif '_lpc' in name:
							with open(DEFAULT_SONVS_LPC_PATH) as f:
								for index, p in enumerate(path):
									index_file = index + 1
									string += f'\ngS{name}_file_{index_file} init "{p}"' + '\n'
									for i in range(int(channels)):
										ch = str(i + 1)
										num = str(index_num)
										file_var = f'gi{name}_{num}'
										file_vars.append(file_var)
										string += f'{file_var} ftgen 0, 0, 0, 1, gS{name}_file_{index_file}, 0, 0, {ch}' + '\n'
										index_num += 1
								
								string += '\n'
								string += f'gi{name}_list[] fillarray {vir.join(file_vars)}\n'
								string += re.sub(r'---NAME---', name, f.read(), flags=re.MULTILINE)	

						elif '_conv' in name:
							with open(DEFAULT_SONVS_CONV_PATH) as f:
								for index, p in enumerate(path):
									index_file = index + 1
									string += f'\ngS{name}_file_{index_file} init "{p}"' + '\n'
									for i in range(int(channels)):
										ch = str(i + 1)
										num = str(index_num)
										file_var = f'gi{name}_{num}'
										file_vars.append(file_var)
										string += f'{file_var} ftgen 0, 0, 0, 1, gS{name}_file_{index_file}, 0, 0, {ch}' + '\n'
										index_num += 1
								
								string += '\n'
								string += f'gi{name}_list[] fillarray {vir.join(file_vars)}\n'
								string += re.sub(r'---NAME---', name, f.read(), flags=re.MULTILINE)							
						else:
							with open(DEFAULT_SONVS_PATH) as f:
								for index, p in enumerate(path):
									index_file = index + 1
									string += f'\ngS{name}_file_{index_file} init "{p}"' + '\n'
									for i in range(int(channels)):
										ch = str(i + 1)
										num = str(index_num)
										file_var = f'gi{name}_{num}'
										file_vars.append(file_var)
										string += f'{file_var} ftgen 0, 0, 0, 1, gS{name}_file_{index_file}, 0, 0, {ch}' + '\n'
										index_num += 1
								
								string += '\n'
								string += f'gi{name}_list[] fillarray {vir.join(file_vars)}\n'
								string += re.sub(r'---NAME---', name, f.read(), flags=re.MULTILINE)
											
						print(string)
						CORDELIA_COMPILE_FIRST.append(string)

						if queue_hybrid:
							CORDELIA_COMPILE_FIRST.extend(queue_hybrid)
							queue_hybrid.clear()

					elif type == 'hybrid':

						required_instr = CORDELIA_INSTR_json[name]['required']
						names.extend(required_instr)

						with open(path) as f:
							#csound_cordelia.compileOrcAsync(f.read())
							string = f.read()
							for index, each in enumerate(required_instr):
								repl = CORDELIA_INSTR_json[required_instr[index]]['path'][index]
								string = re.sub(fr'---REQUIRED_INSTR_PATH_{index+1}---', f'"{repl}"', string, flags=re.MULTILINE)

							queue_hybrid.append(string)
			
				INSTR_HASPLAYED.append(name)

				#and create an array
				instr_setting = f'gS{name}[] init ginchnls\n'
				for each in range(CORDELIA_NCHNLS):
					instr_setting += f'gS{name}[{each}] sprintf	"{name}_%i", {each+1}\n'

				start = CORDELIA_NCHNLS * (len(INSTR_HASPLAYED) - 1) + 1
				sequence = [start + i for i in range(CORDELIA_NCHNLS)]
				for index, val in enumerate(sequence):
					instr_num = 950 + (val/10000)
					instr_setting += f'schedule {round(instr_num, 5)}, 0, -1, "{name}_{index+1}"\n'
				
				if CORDELIA_FOUT_MEMORIES:
					instr_add = (len(INSTR_HASPLAYED))/10000
					instr_setting += f'schedule {round(945+instr_add, 5)}, 0, -1, "{name}", "{CORDELIA_CURRENT_DIR}/cor{CORDELIA_DATE}-{name}.wav"\n'
				
				print(instr_setting)
				#csound_cordelia.compileOrcAsync(instr_setting)
				CORDELIA_COMPILE_FIRST.append(instr_setting)
				print(f'SEND {name}')
				#print(instr_setting)
			
			else:
				if queue_hybrid:
					CORDELIA_COMPILE_FIRST.extend(queue_hybrid)
					queue_hybrid.clear()
			
				
	names.clear()
	return unit

def parser(code) -> str():

	#delete all $ symbol for macros
	code = re.sub(r'\$', '', code, flags=re.MULTILINE)

	try:
		code = abbr(code)
		code = note(code)
		code = macro(code)
		code = scala(code)
		code = gen(code)
		code = instr(code)

		#added for regex parse
		code += '\n'

		#find all unit by new line and separate them 
		units = re.findall(r'^(.(?:\n|.)*?)\n$', code, flags=re.MULTILINE)

		instruments = []

		for unit in units:

			#remove if comment
			if not unit.startswith(';'):

				#remove tabs
				unit = re.sub(r'[\t]*', '', unit)

				for each in Parser(unit).instruments:
					instruments.append(each)

		return instruments

	except Exception as e:
		print(f'This is an exception in {bcolors.WARNING}parser{bcolors.ENDC}')
		print(f'in line: {bcolors.WARNING}{unit}{bcolors.ENDC}')
		print(f'{bcolors.WARNING}{e}{bcolors.ENDC}')
		

	#return code



def parser_rpr(code) -> str():

	#delete all $ symbol for macros
	code = re.sub(r'\$', '', code, flags=re.MULTILINE)

	try:
		code = abbr(code)
		code = note(code)
		code = macro(code)
		code = scala(code)
		code = gen(code)
		code = instr(code)

		#added for regex parse
		code += '\n'


		return code

	except Exception as e:
		print(f'This is an exception in {bcolors.WARNING}parser{bcolors.ENDC}')
		print(f'in line: {bcolors.WARNING}{code}{bcolors.ENDC}')
		print(f'{bcolors.WARNING}{e}{bcolors.ENDC}')
		