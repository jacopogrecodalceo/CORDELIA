from threading import Thread
import queue

from src.node import Node
from src.utils import extract_node
import src.udp as udp
import src.instrument as instrument

from csoundAPI import csound_cordelia

# Create a queue to communicate between threads
message_queue = queue.Queue()

def process_messages():
	while True:
		direction, code = message_queue.get()
		if direction == 'CORDELIA':
		
			# Create Node instances for each extracted node
			nodes = [Node(string) for string in extract_node(code)]

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

			final_instr = instrument.wrapper(instruments)
			csound_cordelia.compileOrc('\n'.join(final_instr))

def csound_perf_homemade(cs):
	cs.start()
	cs.perform()
	cs.cleanup()

	return


if __name__ == '__main__':
	udp.open_ports()
	
	# Create and start the thread for listening to messages
	threads = [Thread(target=udp.listen, daemon=True, args=(message_queue,)),
	    		Thread(target=process_messages, daemon=True),
				Thread(target=csound_perf_homemade, args=(csound_cordelia,))]

	# Process the received messages in the main thread
	for t in threads:
		t.start()

	#csound_cordelia.compileOrc('schedule "heart", 0, -1')
