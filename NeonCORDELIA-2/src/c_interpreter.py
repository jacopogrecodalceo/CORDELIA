
from constants.var import cordelia_compile
from constants.var import cordelia_nchnls

from src.instrument import Instrument

instr_last = ['init']

def cordelia_init():

	global instr_last

	if instr_last[0] == 'init':

		instr_setting = ['schedule "heart", 0, -1']

		name = 'mouth'
		for each in range(cordelia_nchnls):
			instr_num = 950 + ((each+1)/10000)
			instr_setting.append(f'schedule {round(instr_num, 5)}, 0, -1, "{name}_{each+1}"')
		
		instrument = Instrument()
		instrument.code = '\n'.join(instr_setting)
		cordelia_compile.append(instrument)
		instr_last = [None]*12

def compare_instruments_last(instruments):
	
	global instr_last

	codes = [i.code for i in instr_last if i]
	# Update instruments that are still present
	for i, instrument in enumerate(instruments):
		if instrument.code not in codes:
			instrument.status = 'alive'
			instr_last.append(instrument)
			cordelia_compile.append(instrument)

	# Update instruments that are no longer present
	for i, instrument in enumerate(instr_last):
		if instrument and instrument.code not in [i.code for i in instruments]:
			instrument.status = 'dead'
			cordelia_compile.append(instrument)
			instr_last[i] = None
