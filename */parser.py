import pprint

#---receive a list of tokens
#---return code formatted for csound
def parser(tokens):

	instr_start = 500
	instr_max = 24

	cscodes = []

	commands = []
	instrs =[]
	routes = []

	#pprint.pprint(tokens)

	#for readble
	tab_forfstring = chr(10) + chr(9)

	#separate each tokens and put them in a list
	for token in tokens:

		for k in token.keys():

			if 'command' in k:
				commands.append(token['command'])
			elif 'instr' in k:
				instrs.append(token['instr'])
			elif 'route' in k:
				routes.append(token['route'])

	#######################################
	# COMMANDs
	#######################################
	for index, command in enumerate(commands):
		cscode = f'''
	instr {instr_start + index}
{command}
	endin
				'''	
		cscodes.append(cscode)

	#######################################
	# INSTRs
	#######################################
	for index, instr in enumerate(instrs):

		cscode = f'''
	instr {instr_start + index + instr_max}
{instr['addendum_outside']}
if {instr['opcode']['name']}({instr['opcode']['params']}) == 1 then
	{tab_forfstring.join(instr['addendum_inside'])}
	eva({instr['space']}, "{instr['name']}",
	{instr['dur']},
	{instr['dyn']},
	{instr['env']},
	{tab_forfstring.join(instr['freq'])})
endif
	endin
				'''	
		
		cscodes.append(cscode)
	
		#######################################
		# ROUTEs
		#######################################
		#it's a list
		for i in range(len(routes[index]['name'])):
			cscode = f'''
	instr {instr_start + index + i + instr_max * 2 }
{routes[index]['name'][i]}(\"{instr['name']}\", ({routes[index]['params'][i]}))
	endin
				'''	
				
			cscodes.append(cscode)

	return cscodes