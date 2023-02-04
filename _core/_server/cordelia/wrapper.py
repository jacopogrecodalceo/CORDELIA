
new_line = chr(10)
tab = chr(9)
vir = ','

def wrapper(index, i):

	instr_str_num = 500

	if i:
		if i.kill:
			string = f'''
	turnoff2_i {instr_str_num + index}, 0, 1'''

			print(f'**I WILL KILL U**')
			return(string)

		elif i.opcode and not i.name:
			string = f'''
	instr {instr_str_num + index}
{i.opcode[0]}
	endin'''

		elif i.opcode and i.name:

			string = f'''
	instr {instr_str_num + index}
{(new_line).join(i.add_out) if i.add_out else ''}
if {i.opcode[0]}({i.opcode[1]}) == 1 then
	{(new_line + tab).join(i.add_in)}
	eva({(i.space + ', ') if i.space else ''}"{i.name}",
	{i.dur},
	{i.dyn},
	{i.env},
	{(vir + new_line + tab).join(i.freq)})
endif
	endin'''

		elif i.route:
			for each in i.route:
				string = f'''
	instr {instr_str_num + index}
{i.route[0]}("{i.name}", {i.route[1]})	
	endin'''

		string += f'''
	turnoff2_i {instr_str_num + index}, (ksmps / sr) * {index+1}, 1
	schedule {instr_str_num + index}, (ksmps / sr) * {index+1} * 3, -1\n'''


		return(string)

