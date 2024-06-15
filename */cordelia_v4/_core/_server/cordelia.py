from threading import Thread, Event
from datetime import datetime
import traceback, re
import os

import cordelia
import utils.udp as udp
from utils.constants import LINE_SEP, bcolors
from utils.misc import count_time, county_time
from csound import csound_cordelia, ctcsound, CORDELIA_SR, CORDELIA_NCHNLS
import time

from visual import show_spectrogram, init_spectrum

from utils.constants import CORDELIA_COMPILE_FIRST, CORDELIA_COMPILE, CORDELIA_OUT_WAV, CORDELIA_OUT_LOG, CORDELIA_OUT_COR, CORDELIA_CURRENT_DIR
import queue

# Define a thread-safe queue
cordelia_queue = queue.Queue()

CORDELIA_OUT_LOG_open = ''
CORDELIA_OUT_COR_open = ''

cordelia_init = False

start_time = time.time()

def main():

	global cordelia_init
	global CORDELIA_OUT_LOG_open, CORDELIA_OUT_COR_open
	last_code = ''

	while True:

		code = udp.receive_messages()

		if code[0] == 'BRAIN':
			#county_time(start_time, 'BRAIN EVENT RECV')

			try:
				#list of class instrument
				instruments = cordelia.parser(code[1])
				#county_time(start_time, 'BRAIN PARSE')

				#list of string instrument and vars
				contents = cordelia.content(instruments)

				contents_filtered = cordelia.filter(contents)
				wrapped_instruments = cordelia.wrapper(contents_filtered)
				
				if not cordelia_init:
					new_directory = CORDELIA_CURRENT_DIR

					# Check if the directory doesn't exist, then create it
					if not os.path.exists(new_directory):
						os.mkdir(new_directory)
						print(f"Directory '{new_directory}' created successfully.")
					else:
						print(f"Directory '{new_directory}' already exists.")
					CORDELIA_OUT_LOG_open = open(CORDELIA_OUT_LOG, 'w')
					CORDELIA_OUT_COR_open = open(CORDELIA_OUT_COR, 'w')
					cordelia_init = True

				CORDELIA_OUT_LOG_open.write(f'\n---cor{datetime.now()}---\n')
				CORDELIA_OUT_LOG_open.write(f'\n---cor{start_time-time.time()}---\n')
				
				CORDELIA_OUT_COR_open.write(f'\n---cor{datetime.now()}---\n')
				CORDELIA_OUT_COR_open.write(f'\n---cor{start_time-time.time()}---\n')

				for each in wrapped_instruments:

					print(each)
					print(LINE_SEP)
					CORDELIA_COMPILE.append(each)

					CORDELIA_OUT_LOG_open.write(each)
					CORDELIA_OUT_LOG_open.write(LINE_SEP)

				if code[1] != last_code:
					CORDELIA_OUT_COR_open.write(code[1])
					CORDELIA_OUT_COR_open.write(LINE_SEP)
				last_code = code[1]
						
			except Exception:
				traceback.print_exc()
		
		elif code[0] == 'REAPER':
			#list of class instrument
			if not cordelia_init:
				# Replace 'new_directory' with the desired name of the new directory
				new_directory = CORDELIA_CURRENT_DIR

				# Check if the directory doesn't exist, then create it
				if not os.path.exists(new_directory):
					os.mkdir(new_directory)
					print(f"Directory '{new_directory}' created successfully.")
				else:
					print(f"Directory '{new_directory}' already exists.")

				name = 'mouth'
				instr_setting = ''
				for each in range(CORDELIA_NCHNLS):
					instr_num = 950 + ((each+1)/10000)
					instr_setting += f'schedule {round(instr_num, 5)}, 0, -1, "{name}_{each+1}"\n'
				
				CORDELIA_COMPILE.append(instr_setting)
				cordelia_init = True

			if re.findall(';INSTR_BEFORE', code[1]): 
				instr_before = code[1].split(';INSTR_BEFORE')[0]
				instr_core = code[1].split(';INSTR_BEFORE')[1].split(';INSTR_AFTER')[0]
				instr_after = code[1].split(';INSTR_AFTER')[1]
			else: 
				instr_before = ''
				instr_after = ''
				instr_core = code[1]

			each = cordelia.parser_rpr(instr_core).replace('@', '')
			
			content = instr_before + each + instr_after

			print(content)
			print(LINE_SEP)
			CORDELIA_COMPILE.append(content)


		elif code[0] == 'CSOUND':
			if code[1]:
				print(code[1])
				#csound_cordelia.compileOrcAsync(code[1])
				CORDELIA_COMPILE.append(code[1])

	
		#county_time(start_time, 'BEFORE COMPILATION INSTR; GEN; SCALE')
		if CORDELIA_COMPILE_FIRST and CORDELIA_COMPILE:
			retval = csound_cordelia.evalCode('\n'.join(CORDELIA_COMPILE_FIRST))
			CORDELIA_COMPILE_FIRST.clear()
			if retval == 0 and CORDELIA_COMPILE:
				csound_cordelia.compileOrcAsync('\n'.join(CORDELIA_COMPILE))
				CORDELIA_COMPILE.clear()
		elif CORDELIA_COMPILE_FIRST:
			csound_cordelia.evalCode('\n'.join(CORDELIA_COMPILE_FIRST))
			CORDELIA_COMPILE_FIRST.clear()
		elif CORDELIA_COMPILE:
			csound_cordelia.compileOrcAsync('\n'.join(CORDELIA_COMPILE))
			CORDELIA_COMPILE.clear()
		#county_time(start_time, 'END CODE')

RECORD = True

record_init = True


""" # Define the function to be executed in the thread
def csound_perf_homemade(cs, completion_event):
	cs.start()
	
	sr = int(CORDELIA_SR)
	chs = int(CORDELIA_NCHNLS)
	sig = np.reshape(cs.spout(), (-1, chs))  # Reshape the array

	with sf.SoundFile(CORDELIA_OUT_WAV, 'w', samplerate=sr, channels=chs, subtype='PCM_24') as outfile:
		while cs.performKsmps() == 0:
			outfile.write(sig)
			pass

	cs.cleanup()

	# Thread has completed, set the completion event
	completion_event.set()
	return """

# Define the function to be executed in the thread
def csound_perf_homemade(cs, completion_event):
	
	cs.start()

	cs.perform()
	#while cs.performKsmps() == 0:
	#	cordelia_queue.put(cs.spout())  # Put the data into the queue

	cs.cleanup()

	# Thread has completed, set the completion event
	completion_event.set()
	return

			
# Create the completion event
completion_event = Event()

if __name__ == '__main__':

	#county_time(start_time, 'init')
	udp.open_ports()
	#county_time(start_time, 'csound start')
	#cs_return = csound_cordelia.start()
	#pt = ctcsound.CsoundPerformanceThread(csound_cordelia.csound())
	#county_time(start_time, 'thread main OSC')
	t = Thread(target=main, daemon=True)
	#county_time(start_time, 'thread csound')
	csound_thread = Thread(target=csound_perf_homemade, args=(csound_cordelia, completion_event))
	#rec_thread = Thread(target=recording, args=(csound_cordelia, completion_event))

	print('CSOUND is ON!')
	t.start()
	csound_thread.start()
	#init_spectrum()
	# Show the spectrogram in parallel while updating the queue
	while True:
		try:
			cordelia_spout = cordelia_queue.get_nowait()
			#show_spectrogram(cordelia_spout)
		except queue.Empty:
			# If the queue is empty, continue processing or do other tasks
			pass

		if csound_thread.is_alive():
			# Optionally, add a small sleep to avoid busy waiting
			time.sleep(100/CORDELIA_SR)
		else:
			break

	csound_thread.join()

	if CORDELIA_OUT_LOG_open:
		CORDELIA_OUT_LOG_open.close()
		CORDELIA_OUT_COR_open.close()

	print('CSOUND is OFF!')

	del csound_cordelia
	exit()

