import queue
from pathlib import Path
import os, sys
from threading import Thread
import argparse
#import pdb; pdb.set_trace()

import utils.udp as udp 

from src.run import handler_cordelia, handler_reaper_1, handler_reaper_2
from constants.var import cordelia_init_code, memories
#from src.run_handler import handle_input_cordelia, handle_input_reaper
from csoundAPI.cs import csound_cordelia

message_queue = queue.Queue()

def process_args():
	parser = argparse.ArgumentParser(description='CORDELIA SCORE')
	parser.add_argument('--score', '-s', help='Score (optional)')
	args = parser.parse_args()
	return args.score

def process_messages():

	global memories

	while True:
		direction, code = message_queue.get()

		if direction == 'CORDELIA':
			memories = True
			print('CORDELIA:\n')
			csound_cordelia.compileOrcAsync(handler_cordelia(code))
		
		elif direction == 'REAPER':
			print('REAPER:\n')
			instrs = handler_reaper_1(code)
			if cordelia_init_code:
				print('\n'.join(cordelia_init_code))
				csound_cordelia.compileOrcAsync('\n'.join(cordelia_init_code))
			res = handler_reaper_2(instrs)
			print(res)
			csound_cordelia.compileOrcAsync(res)

		elif direction == 'CSOUND':
			print('CSOUND:\n')
			csound_cordelia.compileOrcAsync(code)

def csound_perf_homemade(cs):
	cs.start()
	cs.perform()
	cs.cleanup()

def main():

	input_score = process_args()
	if not input_score:

		udp.open_ports()
		print(csound_cordelia.csound())

		# Create and start the thread for listening to messages
		threads = [
			Thread(target=process_messages, daemon=True), 
			Thread(target=udp.listen, daemon=True, args=(message_queue,)),
			Thread(target=csound_perf_homemade, args=(csound_cordelia,))
			]

		# Process the received messages in the main thread
		for t in threads:
			t.start()
	else:
		input_name = Path(input_score).stem
		input_ext = Path(input_score).suffix[1:]
		input_dir = Path(input_score).parent

		output_score = os.path.join(input_dir, input_name + '-cordelia' + '.orc')

		with open(input_score, 'r') as f:
			code = f.read()

		instrs = handler_reaper_1(code)

		with open(output_score, 'w') as output:	

			with open('./csound_cordelia/setting.orc') as f:
				output.write(f.read())
				output.write('\n;' + ('*'*32) + '\n')

			with open('./csound_cordelia/include.orc', 'r') as f:
				lines = f.readlines()
				for line in lines:
					parts = line.split('"')
					inside_quotes = parts[1::2][0]
					with open(inside_quotes, 'r') as f:
						output.write(f.read())
						output.write('\n;' + ('*'*32) + '\n')

			if cordelia_init_code:
				output.write('\n'.join(cordelia_init_code))
				output.write('\n;' + ('*'*32) + '\n')

			res = handler_reaper_2(instrs)
			output.write(res)
			output.write('\n;' + ('*'*32) + '\n')

		sys.exit(0)

if __name__ == "__main__":
	main()