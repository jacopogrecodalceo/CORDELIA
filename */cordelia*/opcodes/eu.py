import re
import cordelia

from utils.constants import CORDELIA_INTERVAL_json

#list of lines
def eu(unit_lines):

	instrument_lines = []

	instrument = cordelia.Instrument()

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
	instrument.opcode = [opcode_name, opcode_params]

	space = re.search(r'^(.*?)@', instrument_lines[1])
	if space:
		instrument.space = space[1]

	instrument.name = re.findall(r'@(\w+)', instrument_lines[1])

	instrument.dur = instrument_lines[2]
	instrument.dyn = instrument_lines[3]
	instrument.env = instrument_lines[4]

	for each_freq_line in instrument_lines[5:]:
		is_first_note = re.search(r'^(".*")', each_freq_line)
		if is_first_note:

			is_cpstun = re.search(r'^(".*"):', each_freq_line)
			if is_cpstun:
				intervals = each_freq_line.split(':')[1].lstrip().split(' ')
				intervals_togo = ', '.join(intervals)
				#for semitone, notation in CORDELIA_INTERVAL_json.items():
				#	intervals_togo = intervals_togo.replace(notation, semitone)
				#	print(intervals_togo)
				#freq_line = f'cpstun($once(1, 2), ntom({is_cpstun[1]})+once(fillarray({intervals_togo})), gktuning)'
				freq_line = f'cpstun_render(ntom({is_cpstun[1]})+once(fillarray({intervals_togo})), gktuning)'
				
				instrument.freq.append(freq_line)

			else:
				note = re.search(r'^(".*")', each_freq_line)[1]
				cycle = re.search(r'^"\w+"-(\d+)', each_freq_line)[1]
				limit = re.search(r'^"\w+"-\d+\.(\d+)', each_freq_line)[1]
				tab = re.search(r'^"\w+"-\d+\.\d+:(.*)', each_freq_line)[1].strip()

				#freq_line = f'cpstun($once(1, 2), ntom({note})+int(table:k((chnget:k("heart") * {cycle}) % 1, {tab}, 1)*{limit}), gktuning)'
				freq_line = f'cpstun_render(ntom({note})+int(tablekt:k((chnget:k("heart") * {cycle}) % 1, {tab}, 1)*{limit}), gktuning)'
				
				instrument.freq.append(freq_line)

		else:
			instrument.freq.append(each_freq_line)

	route = re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|$)', instrument_lines[1])
	if route:
		for r in route:
			route_name = re.search(r'^\w+', r)[0]
			route_params = re.search(r'^\w+\((.*)\)', r)[1]
			instrument.route.append([route_name, route_params])
	else:
		instrument.route.append(['getmeout', '1'])

	return instrument
