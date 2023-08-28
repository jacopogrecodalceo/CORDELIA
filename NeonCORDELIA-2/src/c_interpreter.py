
from constants.var import cordelia_init_code, cordelia_compile
from csoundAPI.init_csound import cordelia_nchnls
from constants.var import cordelia_instr_start_num

instr_last = ['init']

def cordelia_init():

	global instr_last

	if instr_last[0] == 'init':

		instr_setting = ['schedule "heart", 0, -1']

		name = 'mouth'
		for each in range(cordelia_nchnls):
			instr_num = 950 + ((each+1)/10000)
			instr_setting.append(f'schedule {round(instr_num, 5)}, 0, -1, "{name}_{each+1}"')
		
		cordelia_init_code.append('\n'.join(instr_setting))
		instr_last = [None]

def compare_instruments_last(instruments):
	
	global instr_last

	codes = [i.code for i in instr_last if i]
	# Update instruments that are still present
	for i, instrument in enumerate(instruments):
		if instrument.code not in codes:
			instrument.status = 'alive'
			if i < len(cordelia_compile):
				cordelia_compile[i] = instrument
				instr_last[i] = instrument
			else:
				cordelia_compile.append(instrument)
				instr_last.append(instrument)

	# Update instruments that are no longer present
	for i, instrument in enumerate(instr_last):
		if instrument and instrument.code not in [i.code for i in instruments]:
			instrument.status = 'dead'
			cordelia_compile[i] = instrument
			instr_last[i] = None


def wrapper(index, instrument):
	
	num = cordelia_instr_start_num + index

	if instrument:
		if instrument.status == 'alive':

			string = [f'\tinstr {num}']
			string.append(instrument.code)
			string.append('\tendin')

			string.append(f'turnoff2_i {num}, 0, 1')
			string.append(f'schedule {num}, ksmps / sr, -1')
			
			return '\n'.join(string)

		elif instrument.status == 'dead':
			return f'turnoff2_i {num}, 0, 1\n'

