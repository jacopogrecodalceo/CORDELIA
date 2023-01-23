import re
import cordelia

#list of lines
def eu(unit_lines):

	instrument_lines = []
	
	#create a index line sensible list
	for line in unit_lines:
	
		#ignoring comment
		if not line.startswith(';'):
			#parse for addendum
			if line.startswith('+'):
				line = re.sub(r'^\+', '', line)
				instrument.add_in.append(line)
			elif line.startswith('-'):
				line = re.sub(r'^-', '', line)
				instrument.add_out.append(line)						
			else:
				instrument_lines.append(line)

	opcode_name = instrument_lines[0].split(':')[0]
	opcode_params = instrument_lines[0].split(':')[1].strip()

	instrument = cordelia.Instrument([opcode_name, opcode_params])

	space = re.search(r'^(\w+?)@', instrument_lines[1])
	if space:
		instrument.space = space[1]

	instrument.name = re.findall(r'@(\w+)', instrument_lines[1])
	instrument.dur = instrument_lines[2]
	instrument.dyn = instrument_lines[3]
	instrument.env = instrument_lines[4]
	instrument.freq = instrument_lines[5:]

	for r in re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|$)', instrument_lines[1]):
		route_name = re.search(r'^\w+', r)[0]
		route_params = re.search(r'^\w+\((.*)\)', r)[1]
		instrument.route.append([name, route_name, route_params])

	return instrument
