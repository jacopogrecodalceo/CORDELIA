import re

CORDELIA_ALGORITHM = ["eu", "eujo", "hex", "jex"]

def convert_ins_params(line):

	if not line.startswith('@'):

		line = re.search(r"^(.+?)@", line)[1]

		if re.search(r"^[a-z]", line):
			if re.search(r"^r\d", line):
				line = re.sub(r"^r", 'oncegen(girot', line) + ')'
			elif re.search(r"^l\d", line):
				line = re.sub(r"^l", 'oncegen(giline', line) + ')'
			elif re.search(r"^e\d", line):
				line = re.sub(r"^e", 'oncegen(gieven', line) + ')'
			elif re.search(r"^o\d", line):
				line = re.sub(r"^o", 'oncegen(giodd', line) + ')'
			elif re.search(r"^a\d", line):
				line = re.sub(r"^a", 'oncegen(giarith', line) + ')'
			elif re.search(r"^d\d", line):
				line = re.sub(r"^d", 'oncegen(gidist', line) + ')'

			elif re.search(r"^t", line):
				line = re.sub(r"^t.*(?=(?:@))", '')
		
		elif re.search(r"^-", line):
			if re.search(r"^-r\d", line):
				line = re.sub(r"^-r", 'oncegen(-girot', line) + ')'
			elif re.search(r"^-l\d", line):
				line = re.sub(r"^-l", 'oncegen(-giline', line) + ')'
			elif re.search(r"^-e\d", line):
				line = re.sub(r"^-e", 'oncegen(-gieven', line) + ')'
			elif re.search(r"^-o\d", line):
				line = re.sub(r"^-o", 'oncegen(-giodd', line) + ')'
			elif re.search(r"^-a\d", line):
				line = re.sub(r"^-a", 'oncegen(-giarith', line) + ')'
			elif re.search(r"^-d\d", line):
				line = re.sub(r"^-d", 'oncegen(-gidist', line) + ')'

		line = line + ', '
	else:
		line = ''
	
	return line

def cordelia_to_csound(code):

	converted = [] 
	lines = []

	for line in code.splitlines():
		lines.append(line)

	#===========================
	#LINE BLOCK
	#===========================
	#IF ONE LINE
	if len(lines) == 1:
		line = lines[0]

		#IF STARTS WITH @
		if re.search(r"^@", line):
			line_to_csound = re.sub(r"^@", '', line)
			converted.append(line_to_csound)
		else:
			converted.append(line_to_csound)

	#IF BLOCK		
	else:

		#EXTRACT FROM LIST IF THERE'S A +
		ins_lines = []
		adds = []
		for line in ins_lines:
			line = line.strip()
			if line.startswith('+'):
				line = re.sub(r"\+", '', line)
				adds.append(ins_lines)
			else:
				lines.append(ins_lines)

		alg 		= lines[0]
		alg_name	= re.search(r"^(\w+):", alg)[1]
		alg_params	= re.search(r":\s(.+)", alg)[1]

		#LINE 0, ALGORITHM
		#CHECK IF NAME IS IN DICT
		if alg_name in CORDELIA_ALGORITHM:

			#LINE 1, INSTRUMENT AND ROUTING
			ins 		= lines[1]
			
			#INSTRUMENT LINE HAS 3 ZONES:
			#ZONE_PARAMS @ ZONE_NAMES . ZONE_ROUTES

			#ZONE_PARAMS
			ins_params = convert_ins_params(ins) 

			#ZONE_NAMES
			ins_names = []

			for match in re.finditer(r"@(\w+)", ins):
				ins_names.append(match[1])

			#ZONE_ROUTES
			ins_route_names = []
			ins_route_params = []


			#===========================
			#SCORE BLOCK
			#===========================
			#IF THERE'S A DOT AND A WORD
			if re.search(r"\.(\w+)", ins):
				#SEPARATE EACH ROUTE
				for match in re.finditer(r"\.(\w+\(.*?\))(?=(?:\.)|$)", ins):
					#JUST THE WORD
					ins_route_names.append(re.search(r"\w+", match[1])[0])
					#EVERYTHING INSIDE PARENTHESIS
					ins_route_params.append(re.search(r"\((.*)\)", match[1])[1])
			#IF THERE'S NOTHING, GETMEOUT
			else:
				ins_route_names.append("getmeout")
				ins_route_params.append("1")

			dur 		= lines[2]
			dyn 		= lines[3]
			env			= lines[4]
			cps 		= []
			for i in range(5, len(lines)):
				cps.append(lines[i])
		
			add_to_score = "\n".join(adds)
			cps_to_score = ",\n\t".join(cps)

			for ins_name in ins_names:
				line_to_csound =  f'''
{add_to_score}

if {alg_name}({alg_params}) == 1 then
	eva({ins_params}"{ins_name}",
	{dur},
	{dyn},
	{env},
	{cps_to_score})
endif
'''

				converted.append(line_to_csound)
			
			#===========================
			#ROUTE BLOCK
			#===========================
			for ins_name in ins_names:
				
				route_lines = []
				for ins_route_index, ins_route_name in enumerate(ins_route_names):
					route_lines.append(f'{ins_route_name}(\"{ins_name}\", {ins_route_params[ins_route_index]})')

					line_to_csound = "\n".join(route_lines)
					
					#REMOVE DUPLICATES
					seen = set()
					for i, e in enumerate(route_lines):
						if e in seen:
							route_lines[i] = None
						else:
							seen.add(e)

					converted.append(line_to_csound)

	return "\n".join(converted)
