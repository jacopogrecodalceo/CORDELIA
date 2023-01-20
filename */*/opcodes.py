import re

#list of lines
def eu(list):

	#check if there's more instrs
	#######################################
	# NAME
	#######################################
	#list
	instr_names = re.findall(r'@(\w+)', list[1])

	result = []

	for each_name in instr_names:
		dict = {
			'opcode': {},
			'instr': {},
			'route': {}
		}

		#######################################
		# OPCODE
		#######################################
		#string
		dict['opcode']['name'] = list[0].split(':')[0]
		dict['opcode']['params'] = list[0].split(':')[1].strip()

		#######################################
		# SPACE
		#######################################
		#string
		#facultative
		if re.search(r'^(\w+?)@', list[1]):
			dict['instr']['space'] = re.search(r'^(\w+?)@', list[1])[1]

		#######################################
		# NAME
		#######################################
		#list
		dict['instr']['name'] = each_name

		#######################################
		# ROUTE
		#######################################
		#separate each route
		route = re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|$)', list[1])
		#list
		dict['route']['name'] = []
		dict['route']['params'] = []
		for n in route:
			dict['route']['name'].append(re.search(r'^\w+', n)[0])
			dict['route']['params'].append(re.search(r'^\w+\((.*)\)', n)[1])

		#######################################
		# DURATION
		#######################################
		#string
		dict['instr']['dur'] = list[2]

		#######################################
		# DYNAMIC
		#######################################
		#string
		dict['instr']['dyn'] = list[3]

		#######################################
		# ENVELOPE
		#######################################
		#string
		dict['instr']['env'] = list[4]
		
		#######################################
		# FREQUENCY
		#######################################
		#list
		dict['instr']['freq'] = []
		for i in range(5, len(list)):
			dict['instr']['freq'].append(list[i])

		result.append(dict)

	return result
