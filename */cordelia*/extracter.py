import pprint
from dataclasses import replace
import cordelia

def extracter(instrument):

	instruments = []
	if instrument.name:
		for each_name in instrument.name:

			instrument_head = replace(instrument)
			instrument_head.name = each_name
			instrument_head.route = []
			
			instruments.append(instrument_head)

			for each_route in instrument.route:
				instrument_body = cordelia.Instrument()
				instrument_body.name = each_name
				instrument_body.route = each_route
				
				instruments.append(instrument_body)
	else:
		instruments.append(instrument)

	return instruments
