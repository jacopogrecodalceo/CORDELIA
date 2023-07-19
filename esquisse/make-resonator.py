import json
import re
import pprint

with open('/Users/j/Documents/PROJECTs/CORDELIA/_core/3-body/3-OUT/goj.json') as f:
	CORDELIA_INSTR_json = json.load(f)

instr_name = 'aaron'
route_name = 'convj2'
route_vars = ['gkp1', 'gkp2']

lines = []

def gen_route(instr_name, route_name, route_vars):
	if route_name in CORDELIA_INSTR_json:

		#INIT
		lines.append('''
	if p(4) > 0 then
		ich init p4
	else
		ich init 1
	endif

	if ich < nchnls then
		schedule p1, 0, 1, ich + 1
	endif	
		''')

		#INPUT
		input_line = f'ain chnget sprintf("{instr_name}_%i", ich+1)'
		lines.append(input_line)

		#GAIN IN
		gain_in_line = 'ain *= kgain_in'
		lines.append(gain_in_line)

		#CORE
		core = '\n'.join(CORDELIA_INSTR_json[route_name])
		for index, each in enumerate(route_vars):
			index += 1
			core = re.sub(rf'(\W)P{index}(\W|$)', rf'\1{each}\2', core)
		lines.append(core)

		gain_out_line = 'aout *= kgain_out'
		lines.append(gain_out_line)
		
		output_line = 'chnmix aout, gSmouth[ich]'
		lines.append(output_line)

		return '\n'.join(lines)

print(gen_route(instr_name, route_name, route_vars))