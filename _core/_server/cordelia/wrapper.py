tab_forfstring = chr(10) + chr(9)

def wrapper(index, i):

	if i:
		if i.kill:
			string = f'''
kill {500 + index}'''

			print(f'**I WILL KILL U**')

		elif i.opcode and not i.name:
			string = f'''
	instr {500 + index}
{i.opcode[0]}
	endin'''

		elif i.opcode and i.name:
			string = f'''
	instr {500 + index}
{i.add_in if i.add_in else ''}
if {i.opcode[0]}({i.opcode[1]}) == 1 then
	{tab_forfstring.join(i.add_in)}
	eva({i.space}, "{i.name}",
	{i.dur},
	{i.dyn},
	{i.env},
	{tab_forfstring.join(i.freq)})
endif
	endin'''

		elif i.route:
			string = f'''
	instr {500 + index}
{i.route[0]}(\"{i.name}\", {i.route[1]})
	endin'''

		string += f'\nstart {500 + index}'

		return(string)

