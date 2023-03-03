from utils.constants import CORDELIA_COMPILE, CORDELIA_OUT_WAV
INSTR_LAST = ['init']

def filter(instruments):

	global INSTR_LAST

	if INSTR_LAST[0] == 'init':
		INSTR_LAST = [None]*len(instruments)
		CORDELIA_COMPILE.append('schedule "heart", 0, -1')
		#recording
		CORDELIA_COMPILE.append(f'schedule 985, 0, -1, "{CORDELIA_OUT_WAV}"')
	
	results = [None]*len(INSTR_LAST)

	for index, i in enumerate(instruments):
		if i not in INSTR_LAST:
			if index > len(INSTR_LAST)-1:
				INSTR_LAST.append(i)
				results.append(['alive', i])
			else:
				INSTR_LAST[index] = i
				results[index] = ['alive', i]

	for index, i in enumerate(INSTR_LAST):
		if i and i not in instruments:
			results[index] = ['dead', i]
			INSTR_LAST[index] = None

	return results
