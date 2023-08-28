import re

def extract_elements(string):
    elements = []
    paren_count = 0
    start = 0
    for i, c in enumerate(string):
        if c == '(':
            paren_count += 1
        elif c == ')':
            paren_count -= 1
        elif c == ',' and paren_count == 0:
            elements.append(string[start:i])
            start = i + 1
    elements.append(string[start:])
    return [elem.strip() for elem in elements if elem]


def space(string):
		
	if re.search(r'^[a-z]', string):
		if re.search(r'^r\d', string):
			string = re.sub(r'^r', 'oncegen(girot', string) + ')'
		elif re.search(r'^l\d', string):
			string = re.sub(r'^l', 'oncegen(giline', string) + ')'
		elif re.search(r'^e\d', string):
			string = re.sub(r'^e', 'oncegen(gieven', string) + ')'
		elif re.search(r'^o\d', string):
			string = re.sub(r'^o', 'oncegen(giodd', string) + ')'
		elif re.search(r'^a\d', string):
			string = re.sub(r'^a', 'oncegen(giarith', string) + ')'
		elif re.search(r'^d\d', string):
			string = re.sub(r'^d', 'oncegen(gidist', string) + ')'

	elif re.search(r'^-', string):
		if re.search(r'^-r\d', string):
			string = re.sub(r'^-r', 'oncegen(-girot', string) + ')'
		elif re.search(r'^-l\d', string):
			string = re.sub(r'^-l', 'oncegen(-giline', string) + ')'
		elif re.search(r'^-e\d', string):
			string = re.sub(r'^-e', 'oncegen(-gieven', string) + ')'
		elif re.search(r'^-o\d', string):
			string = re.sub(r'^-o', 'oncegen(-giodd', string) + ')'
		elif re.search(r'^-a\d', string):
			string = re.sub(r'^-a', 'oncegen(-giarith', string) + ')'
		elif re.search(r'^-d\d', string):
			string = re.sub(r'^-d', 'oncegen(-gidist', string) + ')'

	return string

def if_multiple_route_then_reduce_amp(list):
	if len(list) == 2:
		return '*ampdb(-5)'
	elif len(list) == 3:
		return '*ampdb(-7)'
	elif len(list) == 4:
		return '*ampdb(-9)'
	elif len(list) == 5:
		return '*ampdb(-11)'
	else:
		return ''	

from utils.constants import CORDELIA_MODULE_json

def gen_route(instr_name_var, route_classes):
	
	lines = []
	
	#INIT
	lines.append('''
if p4 == 0 then
indx		init 1
until	indx > ginchnls do
	schedule p1 + indx/1000, 0, -1, indx
	indx	+= 1
od
turnoff

else

ich init p4

			xtratim gixtratim

krel		init 0
krel		release
igain		init 1
kgain_in	cosseg 0, .015, 1
kgain_out	init 1

if krel == 1 then
	kgain_in cosseg igain, gixtratim/4, igain/4, gixtratim*3/4, 0 
	kgain_out cosseg igain, gixtratim*3/2, igain, gixtratim/3, 0
endif

''')
	#for index, each in enumerate(route_vars):
	#	init_val = CORDELIA_MODULE_json[route_name]['init'][index]
	#	init = f'P{index+1} init {init_val}'
	#	init = re.sub(rf'(\W|^)P{index+1}(\W|$)', rf'\1{each}\2', init)
	#	lines.append(init)

	#INPUT
	input_line = f'\tamain_in chnget sprintf("%s_%i", "{instr_name_var}", ich)'
	lines.append(input_line)
	input_line = '\tamain_in *= kgain_in'
	lines.append(input_line)

	#GAIN IN
	#gain_in_line = 'ain *= kgain_in'
	#lines.append(gain_in_line)

	#CORE
	for index_route, route_class in enumerate(route_classes):
		index_route += 1
		#print(route_class.name)

		if route_class.name in CORDELIA_MODULE_json:
			#csound_cordelia.compileOrcAsync(f.read())
			string = CORDELIA_MODULE_json[route_class.name]['core']
			for i in range(CORDELIA_MODULE_json[route_class.name]['how_many_p']):
				string = re.sub(rf'(\W|^)PARAM_{i+1}(\W|$)', rf'\1{route_class.list_of_each_var_with_val[i][0]}\2', string)
			
			if index_route == 1:
				input_var = 'amain_in'
			else:
				input_var = f'aparent_out{index_route-1}'

			if index_route == len(route_classes):
				output_var = 'amain_out'
			else:
				output_var = f'aparent_out{index_route}'

			string = re.sub(rf'(\W|^)PARAM_IN(\W|$)', rf'\1{input_var}\2', string)
			string = re.sub(rf'(\W|^)PARAM_OUT(\W|$)', rf'\1{output_var}\2', string)
			lines.append(string)


	#gain_out_line = 'aout *= kgain_out'
	#lines.append(gain_out_line)
	#balance_line = '\tamain_out balance2 amain_out, amain_in'	
	#lines.append(balance_line)
	output_line = '\tchnmix amain_out*kgain_out, gSmouth[ich-1]'
	lines.append(output_line)
	lines.append('\tendif')

	res = '\n'.join(lines)
	
	#print(res)

	return res

def find_once_content(string, var):
    
	if re.search(r'once', string):

		start = string.find("once(")
		if start == -1:
			return None
		count = 1
		i = start + len("once(")
		while i < len(string) and count > 0:
			if string[i] == "(":
				count += 1
			elif string[i] == ")":
				count -= 1
			i += 1
			
		once_string = string [:start] + f'once({var}, fillarray(' + string[start + len("once("):i-1] + '))' + string[i:]
		return once_string	
	else:
		
		return string
