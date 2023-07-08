import re, pprint

import src.udp as udp
from src.node import Node
import src.instrument as instrument

from config.const import CSOUND_COMPILE

def main():

	direction, code = udp.receive_messages()

	if direction == 'CORDELIA':
	
		# Extract nodes from code by separating them based on spaces
		nodes_text = re.findall(r'^(.(?:\n|.)*?)\n$', code, flags=re.MULTILINE)

		# Create Node instances for each extracted node
		nodes = [Node(text) for text in nodes_text]

		# Parse nodes by their names and create corresponding instruments
		instrument_index = 1
		instruments = []
		
		for node in nodes:
			for instrument_name in node.instrument_names:

				# Create parsing_Instrument instance
				par_instrument = instrument.Parsing(instrument_name, node)

				# Create Instrument instance
				var_instrument = instrument.GlobalVariable(instrument_index, par_instrument)
				instruments.append(var_instrument)
				instrument_index += 1

		for i in instruments:
			pprint.pprint(vars(i))

def main():
	udp.open_ports()
	udp_thread = Thread(target=main, daemon=True)



if __name__ == '__main__':
	main()