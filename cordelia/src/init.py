import re

from constants.var import cordelia_init_code
from constants.var import cordelia_given_instr
from constants.var import cordelia_compile

from constants.path import cordelia_score

from csoundAPI.cs import remember, csound_clear_instrument, create_dir
from constants.var import cordelia_alias

instr_last = ['init']

def cordelia_init(memories):

	if instr_last and instr_last[0] == 'init':
		print('INIT CORDELIA')
		instr_setting = ['schedule "heart", 0, -1']
		name = 'mouth'
		instr_setting.extend(csound_clear_instrument(name))

		if memories:
			create_dir(cordelia_score)
			instr_setting.append(remember(name))
		
		cordelia_init_code.append('\n'.join(instr_setting))
		instr_last.clear()

def compare_instruments_last(instruments):
	
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

def add_to_compile(instruments, instrument_res):
	legal_opcodes = ('eva_midi', 'eva_midi_ch')
	# Update instruments that are still present
	for instrument in instruments:
		if instrument.code and not instrument.code.startswith(legal_opcodes):
			instrument.status = 'alive'
			cordelia_compile.append(instrument)
		elif instrument.code.startswith(legal_opcodes):
			instrument_res.append(instrument.code)

# =================================================================
# =================================================================
# =================================================================

def convert_note(code):
	def replace_note(match):
		note_name = match.group(0)[:-1]
		octave = match.group(0)[-1:]
		return f'"{octave}{note_name.upper()}"'

	pattern = r'\b[A-Ga-g](?:[b#])?\d+\b'
	code = re.sub(pattern, replace_note, code)
	return code

def convert_alias(code):
	escaped_replacements = {re.escape(name): repl for name, repl in cordelia_alias['alias'].items()}
	pattern = re.compile(rf'(\W)({"|".join(escaped_replacements.keys())})(\W|$)', re.MULTILINE)
	code = pattern.sub(lambda match: f'{match.group(1)}{escaped_replacements[match.group(2)]}{match.group(3)}', code)
	return code

def convert_complex(code):
	for name, repl in cordelia_alias['complex'].items():
		code = re.sub(rf'{name}', rf'{repl}', code, flags=re.MULTILINE)
	return code

def convert(code):
	current_module = globals()
	function_names = [name for name in current_module if callable(current_module[name])]

	for function_name in function_names:
		if function_name.startswith('convert_'):
			func = current_module[function_name]
			code = func(code)
	return code

