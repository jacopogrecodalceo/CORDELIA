import pprint

# mainly check if an instrument

# - check if already used
# - check duplicates - normally done by dict?

# - check with before
# 	- has the same instr name
# 		- has the same body >> remove it
# 		- has not the same body >> pass it
# 	- has the same route name
# 		- if has the same params >> remove it
# 		- if has not the same params >> kill before with a no release and pass the other

# - check with all the code
# 	- has the same instr name
# 		- has the same body >> remove it
# 		- has not the same body >> pass it
# 	- has the same route name
# 		- if has the same params >> remove it
# 		- if has not the same params >> kill before with a no release and pass the other

commands_current = []
commands_last = []

#commands already check for dups cos is a dict - amazing !
def check_commands(tokens):

	global commands_current, commands_last
	ruled_tokens = []
	
	for index, token in enumerate(tokens):
		string = 'command'
		update = {string: {'func': token[string], 'index': index}}
		if string in token:
			# if it was not before
			if token[string] not in commands_last:
				ruled_tokens.append(update)
			# add the command to the last used
			commands_current.append(token[string])
			# print(token['instr']['name'])
		else:
			ruled_tokens.append(token)
			
	for each_command in commands_last:
		if each_command not in commands_current:
			print(f'**I WILL KILL U**{each_command}')
			commands_last.remove(each_command)

	commands_last = commands_current
	commands_current = []

	#for token in ruled_tokens:
	#	if 'command' in token.keys():
	#		pprint.pprint(token['command'])

	return ruled_tokens

instr_bodies_current = []
instr_bodies_last = []
def check_instrs(tokens):

	global instr_bodies_current, instr_bodies_last

	ruled_tokens = []
	for index, token in enumerate(tokens):
		string = 'instr'
		if string in token:
			# check if body was not there:
			if token[string] not in instr_bodies_last:
				# SENDME
				# if has not the same body >> OK
				ruled_tokens.append({string: token[string]})
			# add the instrument to the last used
			instr_bodies_current.append(token[string])
			token[string].update({'index': index})
		else:
			ruled_tokens.append(token)

	for each_instr in instr_bodies_last:
		if each_instr not in instr_bodies_current:
			name = each_instr['name']
			print(f'**I WILL KILL U {name}**')
			instr_bodies_last.remove(each_instr)
	instr_bodies_last = instr_bodies_current
	instr_bodies_current = []

	return ruled_tokens



instr_routes_current = []
instr_routes_last = []
def check_routes(tokens):

	global instr_routes_current, instr_routes_last

	ruled_tokens = []
	for index, token in enumerate(tokens):
		string = 'route'
		if string in token:
			if token[string] not in instr_routes_last:
				# SENDME
				ruled_tokens.append({string: token[string]})
			# add the instrument to the last used
			instr_routes_current.append(token[string])
			token[string].update({'index': index})
		else:
			ruled_tokens.append(token)

	for each_route in instr_routes_last:
		if each_route not in instr_routes_current:
			name = each_route['instr']
			for each in each_route['name']:
				print(f'**I WILL KILL U {name}.{each}()**')
			instr_routes_last.remove(each_route)
	instr_routes_last = instr_routes_current
	instr_routes_current = []

	return ruled_tokens



def ruler(tokens):

	ruled_tokens = check_commands(tokens)	
	ruled_tokens = check_instrs(ruled_tokens)	
	ruled_tokens = check_routes(ruled_tokens)	

	pprint.pprint(ruled_tokens)

	return ruled_tokens


