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
from csoundAPI.cs import csound_cordelia, init_csound

message_queue = queue.Queue()

def process_args():
	parser = argparse.ArgumentParser(description='CORDELIA SCORE')
	parser.add_argument('--score', '-s', help='Score (optional)')
	parser.add_argument('--jack', '-j', action='store_true', help='Use Csound with -+rtaudio=jack (specifies the audio backend to use)')
	args = parser.parse_args()
	return args

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

def start_jack_connection(ip='169.0.0.1', n_in=4, n_outs=12):
	os.system(f'jackd -r -d net -a {ip} -C{n_in} -P{n_outs}')

def main():
	args = process_args()
	input_score = args.score

	if args.jack:
		csound_cordelia.setOption('-+rtaudio=jack')
		csound_cordelia.setOption('--nchnls_i=4')
		csound_cordelia.setOption('--nchnls=10')

	if not input_score:

		udp.open_ports()
		print(csound_cordelia.csound())

		# Create and start the thread for listening to messages
		threads = [
			#Thread(target=start_jack_connection, daemon=True) if args.jack else None, 
			Thread(target=process_messages, daemon=True), 
			Thread(target=udp.listen, daemon=True, args=(message_queue,)),
			Thread(target=csound_perf_homemade, args=(csound_cordelia,))
			]

		# Process the received messages in the main thread
		for t in threads:
			if t:
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
		for t in threads:
			if t:
				t.stop

		sys.exit(0)

if __name__ == "__main__":
	main()