import re

from constants.var import cordelia_init_code, cordelia_compile
from constants.var import cordelia_instr_start_num
from constants.var import cordelia_given_instr
from constants.var import cordelia_alias

from constants.path import cordelia_score

from csoundAPI.cs import remember, csound_clear_instrument, create_dir

instr_last = ['init']

def cordelia_init(memories):

	global instr_last

	if instr_last and instr_last[0] == 'init':
		print('INIT CORDELIA')
		instr_setting = ['schedule "heart", 0, -1']
		name = 'mouth'
		instr_setting.extend(csound_clear_instrument(name))

		if memories:
			create_dir(cordelia_score)
			instr_setting.append(remember(name))

		cordelia_given_instr.append(name)
		
		cordelia_init_code.append('\n'.join(instr_setting))
		instr_last.clear()

def compare_instruments_last(instruments):
	
	global instr_last

	codes = [i.code if i else None for i in instruments]
	codes_last = [i.code if i else None for i in instr_last]

	# Update instruments that are still present
	for i, instrument in enumerate(instruments):
		if instrument.code not in codes_last:
			instrument.status = 'alive'
			if i < len(cordelia_compile):
				cordelia_compile[i] = instrument
				instr_last[i] = instrument
			else:
				cordelia_compile.append(instrument)
				instr_last.append(instrument)

	# Update instruments that are no longer present
	for i, instrument in enumerate(instr_last):
		if instrument and instrument.code not in codes:
			instrument.status = 'dead'
			cordelia_compile[i] = instrument
			instr_last[i] = None

def perform_alias(code):
	escaped_replacements = {re.escape(name): repl for name, repl in cordelia_alias['alias'].items()}
	pattern = re.compile(rf'(\W)({"|".join(escaped_replacements.keys())})(\W|$)', re.MULTILINE)
	code = pattern.sub(lambda match: f'{match.group(1)}{escaped_replacements[match.group(2)]}{match.group(3)}', code)
	return code

def perform_complex(code):
	for name, repl in cordelia_alias['complex'].items():
		code = re.sub(rf'{name}', rf'{repl}', code, flags=re.MULTILINE)
	return code

def perform_note(code):

	def replace_note(match):
		note_name = match.group(0)[:-1]
		octave = match.group(0)[-1:]
		return f'"{octave}{note_name.upper()}"'

	pattern = r'\b[A-Ga-g](?:[b#])?\d+\b'
	code = re.sub(pattern, replace_note, code)
	return code

def init_conversion(code):
	code = perform_note(code)
	code = perform_alias(code)
	code = perform_complex(code)
	return code

def wrapper(index, instrument):
	
	num = cordelia_instr_start_num + index

	if instrument and instrument.wrap:
		if instrument.status == 'alive':

			string = [f'\tinstr {num}']
			string.append(instrument.code)
			string.append('\tendin')

			string.append(f'turnoff2_i {num}, 0, 1')
			string.append(f'schedule {num}, ksmps / sr, -1')
			
			return '\n'.join(string)

		elif instrument.status == 'dead':
			return f'turnoff2_i {num}, 0, 1\n'

