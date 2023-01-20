import pprint

command_last = []
instr_names_last = []

command_current = []
instr_names_current = []

#mainly check if an instrument

# - check with before - the past
# 		- has the same name
#		 		- has the same body >> do nothing
# 				- has the same route name
#						- if has not the same params >> kill before and then 

# - check with all the code
# 		- has the same name
#		 		- has the same body >> do nothing
#a list of dict
def ruler(tokens):

	global command_last, instr_names_last
	global command_current, instr_names_current

	ruled_tokens = []

	#######################################
	# CHECK IF SAME INSTRUMENT
	#######################################

	for token in tokens:

		if 'command' in token.keys():
			#if it was not before
			if not token['command'] in command_last:
				ruled_tokens.append(token)
			#add the command to the last used
			command_current.append(token['command'])
			#print(token['instr']['name'])

		if 'instr' in token.keys():
			#if name was not used before
			if not token['instr']['name'] in instr_names_last:
				ruled_tokens.append(token)
			else:
				#if name was used before check if:
				# - name was used before 
				if token['instr'] in instr

			#add the instrument to the last used
			instr_names_current.append(token['instr']['name'])
			#print(token['instr']['name'])

	#print(instr_names_current, instr_names_last)
	#print(command_current, command_last)

	#######################################
	# REPLACE LISTs
	#######################################
	for each_command in command_last:
		if not each_command in command_current:
			print(f'**I WILL KILL U**{each_command}')
			command_last.remove(each_command)

	for each_instr in instr_names_last:
		if not each_instr in instr_names_current:
			print(f'**I WILL KILL U**{each_instr}', each_instr)
			instr_names_last.remove(each_instr)

	command_last = command_current
	instr_names_last = instr_names_current

	command_current = []
	instr_names_current = []

	#pprint.pprint(ruled_tokens)

	return ruled_tokens
