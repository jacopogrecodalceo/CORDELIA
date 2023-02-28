import re
import cordelia

from utils.constants import CORDELIA_INTERVAL_json

#list of lines
def sonvs(string):

	instrument = cordelia.Instrument()

	#ignoring comment
	if not string.startswith(';'):

		space = re.search(r'^(.*?)@', string)
		if space:
			instrument.space = space[1]

		name = re.search(r'@(\w+)', string)[1]
		instrument.name = re.findall(r'@(\w+)', string)
		params = re.findall(r':(.*)', string)[0]
		instrument.add_out = f'{name}({params})'

		route = re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|$)', string)
		if route:
			for r in route:
				route_name = re.search(r'^\w+', r)[0]
				route_params = re.search(r'^\w+\((.*)\)', r)[1]
				instrument.route.append([route_name, route_params])
		else:
			instrument.route.append(['getmeout', '1'])

	return instrument
