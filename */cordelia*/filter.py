INSTR_LAST = ['init']

def filter(instruments):

	global INSTR_LAST

	if INSTR_LAST[0] == 'init':
		INSTR_LAST = [None]*len(instruments)
	
	instrument_filtered = [None]*len(INSTR_LAST)

	for index, i in enumerate(instruments):
		if i in INSTR_LAST:
			print(f'**I WAS USED**')
		else:
			if index > len(INSTR_LAST)-1:
				INSTR_LAST.append(i)
				instrument_filtered.append(i)
			else:
				INSTR_LAST[index] = i
				instrument_filtered[index] = i
	
	for index, i in enumerate(INSTR_LAST):
		if i and i not in instruments:
			i.kill = True
			instrument_filtered[index] = i
			INSTR_LAST[index] = None

	return instrument_filtered
