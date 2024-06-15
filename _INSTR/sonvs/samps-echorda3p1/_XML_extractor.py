import os

wav_dir_path = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-echorda3p1'


wav_files = [f for f in os.listdir(wav_dir_path) if f.endswith('01.aif')]

    
if_statements = []

note_nums_extracted = []
for f in wav_files:

	#ECHORDA3_P1_26_D1_03.aif
	midi_num = f.split('_')[-3]#.split('.')[0]
	note_name = f.split('_')[-2]#.split('.')[0]
	note_nums_extracted.append((note_name, int(midi_num)))

sorted_note_nums_extracted = sorted(note_nums_extracted, key=lambda x: x[1])

for i in range(len(sorted_note_nums_extracted)-1):
	note_name, note_num = sorted_note_nums_extracted[i]
	next_note_name, next_note_num = sorted_note_nums_extracted[i + 1]
	if i == 0:
		lo_note = 0
		hi_note = next_note_num-1
		root_note = note_num
		if_statement = f'''if inote <= {hi_note} && inote > {lo_note} then
	irootnote = {root_note}
	Snote_name init "{note_name}"'''
		if_statements.append(if_statement)

	elif i < len(sorted_note_nums_extracted)-2:
		lo_note = note_num-1
		hi_note = next_note_num-1
		root_note = note_num	
		if_statement = f'''elseif inote <= {hi_note} && inote > {lo_note} then
	irootnote = {root_note}
	Snote_name init "{note_name}"'''	

		if_statements.append(if_statement)
	elif i == len(sorted_note_nums_extracted)-2:
		lo_note = note_num-1
		hi_note = 127
		root_note = next_note_num
		if_statement = f'''elseif inote <= {hi_note} && inote > {lo_note} then
	irootnote = {root_note}
	Snote_name init "{next_note_name}"'''	

		if_statements.append(if_statement)

if_statements.append('endif')

for line in if_statements:
    print(line)
 
