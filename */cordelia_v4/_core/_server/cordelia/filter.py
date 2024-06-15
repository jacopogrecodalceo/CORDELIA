from utils.constants import CORDELIA_COMPILE, CORDELIA_CURRENT_DIR, CORDELIA_DATE, INSTR_HASPLAYED, CORDELIA_FOUT_MEMORIES
from csound import CORDELIA_NCHNLS

INSTR_LAST = ['init']

def filter(instruments):

	global INSTR_LAST

	if INSTR_LAST[0] == 'init':

		INSTR_LAST = [None]*len(instruments)
		CORDELIA_COMPILE.append('schedule "heart", 0, -1')

		name = 'mouth'
		instr_setting = ''
		for each in range(CORDELIA_NCHNLS):
			instr_num = 950 + ((each+1)/10000)
			instr_setting += f'schedule {round(instr_num, 5)}, 0, -1, "{name}_{each+1}"\n'
		
		CORDELIA_COMPILE.append(instr_setting)
		print(instr_setting)
		if CORDELIA_FOUT_MEMORIES:
			CORDELIA_COMPILE.append('gieva_memories init 0\n')
			CORDELIA_COMPILE.append(f'schedule +{945+(1/10000)}, 0, -1, "{name}", "{CORDELIA_CURRENT_DIR}/main-cor{CORDELIA_DATE}.wav"')

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
