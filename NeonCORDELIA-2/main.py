import time
import queue
import sys

from threading import Thread

import utils.udp as udp 

from src.run import handle_input
from csoundAPI.init_csound import csound_cordelia

message_queue = queue.Queue()

def process_messages():
	while True:
		direction, code = message_queue.get()
		if direction == 'CORDELIA':	
			csound_cordelia.compileOrcAsync(handle_input(code))

def csound_perf_homemade(cs):
	
	cs.start()
	cs.perform()
	cs.cleanup()

def main():
	udp.open_ports()

	# Create and start the thread for listening to messages
	threads = [
		Thread(target=process_messages, daemon=True), 
	    Thread(target=udp.listen, daemon=True, args=(message_queue,)),
		Thread(target=csound_perf_homemade, args=(csound_cordelia,))]

	# Process the received messages in the main thread
	for t in threads:
		t.start()

	""" try:
		while True:
			time.sleep(.5)
	except KeyboardInterrupt:
		print("Threads stopped. Exiting.")
		sys.exit(0)  # Cleanly exit the program
 """
if __name__ == "__main__":
	main()