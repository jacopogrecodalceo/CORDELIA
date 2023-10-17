from cordelia.conversion import gen_route, find_once_content
new_line = chr(10)
tab = chr(9)
vir = ', '

def content(instrument_classes):
	
	contents = []

	remove_route_duplicates = []

	instrument_names_in_content = []

	for index_instr, instrument_class in enumerate(instrument_classes):

		breed = instrument_class.breed

		index_instr += 1

		if breed == 'control':
			contents.append(instrument_class.csound_code)
		
		elif breed == 'aural_instrument':

			rhythm_var = f'gkrhy_{index_instr}'
			rhythm_content = f'{rhythm_var} {instrument_class.rhythm_name} {instrument_class.rhythm_p}'
			contents.append(rhythm_content)

			if_openvar = f'\tif {rhythm_var} != 0 then\n'
			if_closevar = f'\n\tendif'

			space_var = f'gkspace_{index_instr}'
			contents.append(f'{if_openvar}{space_var} = {instrument_class.space}{if_closevar}')

			name_var = f'gSname_{index_instr}'
			contents.append(f'{name_var} = "{instrument_class.name}"')
			instrument_names_in_content.append(instrument_class.name)

			dur_var = f'gkdur_{index_instr}'
			instrument_class.dur = find_once_content(instrument_class.dur, rhythm_var)
			if instrument_class.dur.startswith('each'):
				dur_each = instrument_class.dur.replace('each(', f'each({rhythm_var}, ')
				dur_content = f'{dur_var} = {dur_each}'
			else:
				dur_content = f'{dur_var} = {instrument_class.dur}'
			contents.append(dur_content)

			dyn_var = f'gkdyn_{index_instr}'
			instrument_class.dyn = find_once_content(instrument_class.dyn, rhythm_var)
			if instrument_class.dyn.startswith('each'):
				dyn_each = instrument_class.dyn.replace('each(', f'each({rhythm_var}, ')
				dyn_content = f'{dyn_var} = {dyn_each}*({rhythm_var} == 1 ? ampdb(5) : 1)'
			else:
				#dyn_content = f'{dyn_var} = {instrument_class.dyn}*({rhythm_var} == 1 ? ampdb(5) : 1)'
				dyn_content = f'{dyn_var} = {instrument_class.dyn}'
			contents.append(dyn_content)

			env_var = f'gkenv_{index_instr}'
			instrument_class.env = find_once_content(instrument_class.env, rhythm_var)
			if instrument_class.env.startswith('each'):
				env_each = instrument_class.env.replace('each(', f'each({rhythm_var}, ')
				env_content = f'{env_var} = {env_each}'
			else:
				env_content = f'{env_var} = {instrument_class.env}'
			contents.append(env_content)

			freqs = []
			for i in range(5):
				if i <= (len(instrument_class.freq)-1):
					#print(instrument_class.freq[i])
					freq_var = f'gkfreq_{index_instr}_{i+1}'
					freqs.append(freq_var)
					instrument_class.freq[i] = find_once_content(instrument_class.freq[i], rhythm_var)
					freq_content = f'{if_openvar}{freq_var} = {instrument_class.freq[i]}{if_closevar}'
					contents.append(freq_content)
				#else:
					#freq_var = f'gkfreq_{index}_{i+1}'
					#contents.append(f'{freq_var} = 0')
			
			string_main = f'''

if {rhythm_var} != 0 then
	{instrument_class.origin}({space_var}, {name_var},
	{dur_var},
	{dyn_var},
	{env_var},
	{(vir + new_line + tab).join(freqs)})
endif'''

			contents.append(string_main)

		elif breed == 'aural_route':

			for index_route, route_class in enumerate(instrument_class.route_classes):
				params_for_duplicates = [instrument_class.name, route_class.name, route_class.values]


				if params_for_duplicates not in remove_route_duplicates:
					index_route += 1
					
					route_class.list_of_each_var_with_val = []

					for index_var, value in enumerate(route_class.values):
						index_var += 1

						if value in instrument_names_in_content:
							gvar = f'gS{route_class.name}_{index_instr}_{index_route}_p{index_var}'
							contents.append(f'{gvar} = "{value}"')
							
						else:
							gvar = f'gk{route_class.name}_{index_instr}_{index_route}_p{index_var}'
							contents.append(f'{gvar} = {value}')

						route_class.list_of_each_var_with_val.append((gvar, value))

					remove_route_duplicates.append(params_for_duplicates)

			for index_route, route_class in enumerate(instrument_class.route_classes):
				if hasattr(route_class, 'list_of_each_var_with_val'):
					string_main = gen_route(instrument_class.name, instrument_class.route_classes)
			contents.append(string_main)

	instrument_names_in_content.clear()
	remove_route_duplicates.clear()

	return contents
