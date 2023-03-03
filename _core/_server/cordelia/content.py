from cordelia.conversion import gen_route

new_line = chr(10)
tab = chr(9)
vir = ', '

def content(instrument_classes):
	
	contents = []

	remove_route_duplicates = []

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

			dur_var = f'gkdur_{index_instr}'
			contents.append(f'{dur_var} = {instrument_class.dur}')

			dyn_var = f'gkdyn_{index_instr}'
			contents.append(f'{dyn_var} = {instrument_class.dyn}')

			env_var = f'gkenv_{index_instr}'
			contents.append(f'{env_var} = {instrument_class.env}')

			freqs = []
			for i in range(5):
				if i <= (len(instrument_class.freq)-1):
					#print(instrument_class.freq[i])
					freq_var = f'gkfreq_{index_instr}_{i+1}'
					freqs.append(freq_var)
					contents.append(f'{if_openvar}{freq_var} = {instrument_class.freq[i]}{if_closevar}')
				#else:
					#freq_var = f'gkfreq_{index}_{i+1}'
					#contents.append(f'{freq_var} = 0')
			
			string_main = f'''

if {rhythm_var}	== 1 then
	kaccent = ampdb(5)
else
	kaccent = 1
endif

if {rhythm_var} != 0 then
	eva({space_var}, {name_var},
	{dur_var},
	{dyn_var}*kaccent,
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
							gkvar = f'gk{route_class.name}_{index_instr}_{index_route}_p{index_var}'
							contents.append(f'{gkvar} = {value}')
							
							route_class.list_of_each_var_with_val.append((gkvar, value))
							
						remove_route_duplicates.append(params_for_duplicates)


				string_main = gen_route(instrument_class.name, instrument_class.route_classes)
				contents.append(string_main)

	remove_route_duplicates.clear()

	return contents
