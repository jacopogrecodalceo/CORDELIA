import re
import pprint

from constants.var import cordelia_instr_start_num
from constants.var import cordelia_json

#from utils.debug import line_profile_it

names_last = {}
routing_json = cordelia_json['ROUTING']
attribute_order = ['name', 'rhythm', 'space', 'dur', 'dyn', 'env', 'freq', 'core', 'routing', 'code']

PRINT_DICT = False

def create_id(instruments):

	name_counts = {}

	# Create variables for each instrument
	for i in instruments:
		# ----------------------------------------------------------------
		name = i.name
		name_count = name_counts.get(name, 0) + 1
		name_counts[name] = name_count
		name_var = f'{name}_{name_count}'
		if name_var in names_last:
			i.name_id = names_last[name_var]
		else:
			i.name_id = len(names_last) + 1
			names_last[name_var] = i.name_id
		# ----------------------------------------------------------------

	return instruments

# =================================================================
# =================================================================
# =================================================================

def explicit(virgin_instruments):

	"""Explicit certains attributes of a given instrument and make variables"""

	virgin_instruments = create_id(virgin_instruments)

	explicit_instruments = []

	for instrument in virgin_instruments:
		if instrument.name != 'cordelia':
			if instrument.space:
				instrument = explicit_space(instrument)

			if instrument.routing:
				instrument = explicit_routing(instrument)

			instrument = make_variables(instrument)

			explicit_instruments.append(instrument)
		else:
			explicit_instruments.append(instrument)
	
	if PRINT_DICT:
		for i in explicit_instruments:
			pprint.pprint(vars(i))
	
	return explicit_instruments

def explicit_space(instrument):
	space = instrument.space
	if space != 0:
		replacements = {
						'r': 'girot',
						'l': 'giline',
						'e': 'gieven',
						'o': 'giodd',
						'a': 'giarith',
						'd': 'gidist',
						}

		for prefix, replacement in replacements.items():
			if re.search(f'^[-]?{prefix}\d+', space):
				prestring = space.replace(f'{prefix}', f'{replacement}')
				instrument.space = f'oncegen({prestring})'
		
	return instrument

def explicit_routing(instrument):

	# Exemple:
	# instrument.routing = [
	# 	{'name': 'moij', 'params': ['ntof(3)', '.95']},
	# 	{'name': 'tapij', 'params': ['3']},
	# 	{'name': 'convij', 'params': ['aaron', '2']}
	# ]

	#INIT
	lines = ['''
if p4 == 0 then

indx        init 1
until   indx > ginchnls do
	schedule p1 + indx/1000, 0, -1, indx
	indx    += 1
od

turnoff

else

ich init p4
xtratim gixtratim

krel 		init 0
krel        release
igain       init 1
kgain_in    cosseg 0, .015, 1
kgain_out   init 1

if krel == 1 then
	kgain_in cosseg igain, gixtratim/4, 0, gixtratim*3/4, 0 
	kgain_out cosseg igain, gixtratim*2/3, igain, gixtratim/3, 0
endif
''']

	lines.extend([
		f'\tamain_in chnget sprintf("%s_%i", "{instrument.name}", ich)',
		'\tamain_in *= kgain_in'
	])
	# Add name to instrument
	#route_var = f'gS{route_dict["name"]}{route_name_id}_{name}{instrument.name_id}_p1'
	#route_dict['params'].insert(0, (route_var, f'"{name}"')) 
	#    
	params_updated = []
	for rounting_name_id, routing in enumerate(instrument.routing, start = 1):
		routing_vars = []
		name = routing['name']
		xin = routing_json[name]['input']
		for i, var_type in enumerate(xin):
			routing_var = f'g{var_type}{name}{rounting_name_id}_{instrument.name}{instrument.name_id}_p{i + 1}'
			if 'params' in routing:
				param_value = routing['params'][i] if i < len(routing['params']) else None
			else:
				param_value = None
			routing_vars.append(routing_var)
			if param_value:
				param_value = f'"{param_value}"' if var_type == 'S' else param_value
				params_updated.append(f'{routing_var} = {param_value}')
		
		string = routing_json[name]['core']
		for i in range(len(xin)):
			route_var = routing_vars[i]
			string = re.sub(rf'(\W|^)PARAM_{i + 1}(\W|$)', rf'\1{route_var}\2', string)

		input_var = 'amain_in' if rounting_name_id == 1 else f'aparent_out{rounting_name_id - 1}'
		output_var = 'amain_out' if rounting_name_id == len(instrument.routing) else f'aparent_out{rounting_name_id}'

		string = re.sub(r'(\W|^)PARAM_IN(\W|$)', rf'\1{input_var}\2', string)
		string = re.sub(r'(\W|^)PARAM_OUT(\W|$)', rf'\1{output_var}\2', string)
		
		lines.append('\n;---\n')
		lines.append(string)
		lines.append('\n;---\n')

	lines.extend([
		'\tchnmix amain_out*kgain_out, gSmouth[ich-1]',
		'endif'
	])

	if instrument.num:
		instrument.routing = '\n'.join(params_updated + lines)
	else:
		instrument.routing = params_updated
		instrument.routing.append('\n'.join(lines))

	return instrument

# =================================================================
# =================================================================
# =================================================================

class Instrument:
	pass

def insert_each(rhythm_var, var):
	if len(var) == 1:
		res = var[0]
	elif len(var) == 2:
		res = f'{rhythm_var} == 1 ? {var[0]} : {var[1]}'
	elif len(var) == 3:
		res = f'{rhythm_var} == {var[2]} ? {var[0]} : {var[1]}'
	else:
		res = var
	return res

def make_variables(instrument):

	instrument_name = instrument.name
	
	rhythm_var = None

	if hasattr(instrument, 'rhythm') and instrument.rhythm is not None:
		rhythm_var = f'gkrhythm_{instrument_name}{instrument.name_id}'
		instrument.rhythm = f'{rhythm_var} {instrument.rhythm["name"]} {", ".join(instrument.rhythm["params"] if isinstance(instrument.rhythm["params"], list) else [instrument.rhythm["params"]])}'

		if_openvar = f'\tif {rhythm_var} != 0 then\n'
		if_closevar = f'\n\tendif'

	if hasattr(instrument, 'space') and instrument.space is not None:
		space_var = f'gkspace_{instrument_name}{instrument.name_id}'
		space = instrument.space[0] if isinstance(instrument.space, list) else instrument.space
		if space != '':
			instrument.space = f'{if_openvar}{space_var} = {space}{if_closevar}'
		else:
			instrument.space = f'{space_var} = 0'

	if instrument.num is None:
		name_var = f'gSname_{instrument_name}{instrument.name_id}'
		instrument.name = f'{name_var} = "{instrument.name}"'
	else:
		instrument.name = None

	if hasattr(instrument, 'dur') and instrument.dur is not None:
		dur_var = f'gkdur_{instrument_name}{instrument.name_id}'
		dur = insert_each(rhythm_var, instrument.dur)
		instrument.dur = f'{dur_var} = {dur}'

	if hasattr(instrument, 'dyn') and instrument.dyn is not None:
		dyn_var = f'gkdyn_{instrument_name}{instrument.name_id}'
		dyn = insert_each(rhythm_var, instrument.dyn)
		#instrument.dyn = f'{dyn_var} = {dyn}*({rhythm_var} == 1 ? ampdb(5) : 1)'
		instrument.dyn = f'{dyn_var} = {dyn}'

	if hasattr(instrument, 'env') and instrument.env is not None:
		env_var = f'gkenv_{instrument_name}{instrument.name_id}'
		env = instrument.env[0] if isinstance(instrument.env, list) else instrument.env
		instrument.env = f'{env_var} = {env}'

	if hasattr(instrument, 'freq') and instrument.freq is not None:
		freq_updated = []
		freq_vars = []
		for i, freq in enumerate(instrument.freq):
			#print(instrument.freq[i])
			freq_var = f'gkfreq{i + 1}_{instrument_name}{instrument.name_id}'
			freq_vars.append(freq_var)
			freq_updated.append(f'{freq_var} = {freq}')
	
		instrument.freq = freq_updated
	
	if rhythm_var:
		instrument.core = f'''
if {rhythm_var} != 0 then
eva({space_var}, {name_var},
{dur_var},
{dyn_var},
{env_var},
{", ".join(freq_vars)})
endif\n'''

	return instrument

def separate(instruments):

	separated_instruments = []

	for i in instruments:
		for attr in [getattr(i, name) for name in attribute_order if hasattr(i, name)]:
			if attr:
				if isinstance(attr, list):
					for a in attr:
						instrument = Instrument()
						instrument.index = i.name_id
						instrument.code = a
						instrument.wrap = i.wrap
						instrument.num = i.num
						instrument.sched_onset = i.sched_onset if hasattr(i, 'sched_onset') else None
						instrument.sched_dur = i.sched_dur if hasattr(i, 'sched_dur') else None
						separated_instruments.append(instrument)
				else:
					if attr != 'cordelia':
						instrument = Instrument()
						instrument.index = i.name_id
						instrument.code = attr
						instrument.wrap = i.wrap
						instrument.num = i.num
						separated_instruments.append(instrument)

	return separated_instruments

# =================================================================
# =================================================================
# =================================================================

def wrap(index, instrument):
	
	if instrument:
		sched_onset = instrument.sched_onset if hasattr(instrument, 'sched_onset') and instrument.sched_onset else "ksmps / sr"
		sched_dur = instrument.sched_dur if hasattr(instrument, 'sched_dur') and instrument.sched_dur else "-1"

		if instrument.wrap:
			num = instrument.num if instrument.num else cordelia_instr_start_num + index
			if instrument.status == 'alive':

				string = [f'\tinstr {num}']
				string.append(instrument.code)
				string.append('\tendin')

				string.append(f'turnoff2_i {num}, 0, 1')
				string.append(f'schedule {num}, {sched_onset}, {sched_dur}')
				return '\n'.join(string)

			elif instrument.status == 'dead':
				return f'turnoff2_i {num}, 0, 1\n'
		else:
			return instrument.code


