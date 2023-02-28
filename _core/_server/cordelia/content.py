new_line = chr(10)
tab = chr(9)
vir = ', '

def content(instrument_classes):
	
	contents = []
	route_dup = []

	for index, instrument_class in enumerate(instrument_classes):

		breed = instrument_class.breed

		index += 1

		if breed == 'control':
			contents.append(instrument_class.csound_code)
		
		elif breed == 'aural_instrument':

			rhythm_var = f'gkrhy_{index}'
			contents.append(f'{rhythm_var} = {instrument_class.rhythm_name}({instrument_class.rhythm_p})')
			if_openvar = f'\tif {rhythm_var} == 1 then\n'
			if_closevar = f'\n\tendif'

			space_var = f'gkspace_{index}'
			contents.append(f'{if_openvar}{space_var} = {instrument_class.space}{if_closevar}')

			name_var = f'gSname_{index}'
			contents.append(f'{name_var} = "{instrument_class.name}"')

			dur_var = f'gkdur_{index}'
			contents.append(f'{dur_var} = {instrument_class.dur}')

			dyn_var = f'gkdyn_{index}'
			contents.append(f'{dyn_var} = {instrument_class.dyn}')

			env_var = f'gkenv_{index}'
			contents.append(f'{env_var} = {instrument_class.env}')

			freqs = []
			for i in range(5):
				try:
					freq_var = f'gkfreq_{index}_{i+1}'
					freqs.append(freq_var)
					contents.append(f'{if_openvar}{freq_var} = {instrument_class.freq[i]}{if_closevar}')
				except:
					freq_var = f'gkfreq_{index}_{i+1}'
					contents.append(f'{freq_var} = 0')
			
			string_main = f'''
if {rhythm_var} == 1 then
	eva({space_var}, {name_var},
	{dur_var},
	{dyn_var},
	{env_var},
	{(vir + new_line + tab).join(freqs)})
endif'''

			contents.append(string_main)

		elif breed == 'aural_route':
			
			route_vars = []

			dup = [instrument_class.name, instrument_class.route[0]]
			if dup not in route_dup:
			
				for i, each in enumerate(instrument_class.route):
					for j, value in enumerate(each[1]):
						var_name = f'gkroute_{index}_{i+1}_p{j+1}'
						route_vars.append(var_name)
						contents.append(f'{var_name} = {value}')
					
					string_main = f'{each[0]}("{instrument_class.name}", {vir.join(route_vars)})'
					contents.append(string_main)
					route_dup.append(dup)
			
					route_vars.clear()

	route_dup.clear()

	return contents
