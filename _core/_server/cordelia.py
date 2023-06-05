from threading import Thread, Event
from datetime import datetime
import traceback, re
import numpy as np
import soundfile as sf


import cordelia
import utils.udp as udp
from utils.constants import LINE_SEP, bcolors
from utils.misc import count_time, county_time
from csound import csound_cordelia, ctcsound, CORDELIA_SR, CORDELIA_NCHNLS
import time

from utils.constants import CORDELIA_COMPILE_FIRST, CORDELIA_COMPILE, CORDELIA_OUT_WAV, CORDELIA_OUT_RAW, CORDELIA_OUT_LOG, CORDELIA_OUT_COR

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
		if CORDELIA_COMPILE_FIRST:
			csound_cordelia.compileOrc('\n'.join(CORDELIA_COMPILE_FIRST))
			CORDELIA_COMPILE_FIRST.clear()	
		#county_time(start_time, 'BEFORE CODE')

		if CORDELIA_COMPILE:
			csound_cordelia.compileOrcAsync('\n'.join(CORDELIA_COMPILE))
			CORDELIA_COMPILE.clear()
		#county_time(start_time, 'END CODE')

RECORD = True

record_init = True

# Define the function to be executed in the thread
def csound_perf_homemade(cs, completion_event):
	cs.start()
	
	sr = int(CORDELIA_SR)
	chs = int(CORDELIA_NCHNLS)
	sig = np.reshape(cs.spout(), (-1, chs))  # Reshape the array

	with sf.SoundFile(CORDELIA_OUT_WAV, 'w', samplerate=sr, channels=chs, subtype='PCM_24') as outfile:
		while cs.performKsmps() == 0:
			outfile.write(sig)

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
		#pt.play()

	# Monitor the thread using the completion event
	while not completion_event.is_set():
		""" 
		if RECORD and cordelia_init and record_init:
			#rec_thread.start()
			print(f'RECORDING IS {cordelia_init}')
			record_init = False

 """
		time.sleep(1/(CORDELIA_SR/16))
	
	csound_thread.join()
	#if not record_init:
		#rec_thread.join()
		

#		while pt.status() == 0:	


		#pt.stopRecord()


		#print('Record OFF')
	
	if CORDELIA_OUT_LOG_open:
		CORDELIA_OUT_LOG_open.close()
		CORDELIA_OUT_COR_open.close()

	#if not record_init:
	#	tfm = sox.Transformer()
	#	min_silence_duration = 3.5
	#	#tfm.silence(1, .015, min_silence_duration, True)
	#	tfm.set_input_format(ignore_length=True)
	#	tfm.build(CORDELIA_OUT_RAW, CORDELIA_OUT_WAV)

	print('CSOUND is OFF!')

	del csound_cordelia
	exit()
