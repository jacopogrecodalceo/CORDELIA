from threading import Thread
from datetime import datetime
import traceback, re

import sox

import cordelia
import utils.udp as udp
from utils.constants import LINE_SEP, bcolors
from utils.misc import count_time
from csound import csound_cordelia, ctcsound, CORDELIA_SR, CORDELIA_NCHNLS

from utils.constants import CORDELIA_COMPILE_FIRST, CORDELIA_COMPILE, CORDELIA_OUT_WAV, CORDELIA_OUT_RAW, CORDELIA_OUT_LOG, CORDELIA_OUT_COR

CORDELIA_OUT_LOG_open = open(CORDELIA_OUT_LOG, 'w')
CORDELIA_OUT_COR_open = open(CORDELIA_OUT_COR, 'w')

cordelia_init = False

def main():

	global cordelia_init

	while True:
		code = udp.receive_messages()

		if code[0] == 'BRAIN':

			try:
				#list of class instrument
				instruments = cordelia.parser(code[1])

				#list of string instrument and vars
				contents = cordelia.content(instruments)

				contents_filtered = cordelia.filter(contents)
				wrapped_instruments = cordelia.wrapper(contents_filtered)

				CORDELIA_OUT_LOG_open.write(f'\n---cor{datetime.now()}---\n')
				CORDELIA_OUT_COR_open.write(f'\n---cor{datetime.now()}---\n')

				for each in wrapped_instruments:

					if not cordelia_init:
						cordelia_init = True

					print(each)
					print(LINE_SEP)
					CORDELIA_COMPILE.append(each)

					CORDELIA_OUT_LOG_open.write(each)
					CORDELIA_OUT_LOG_open.write(LINE_SEP)

					CORDELIA_OUT_COR_open.write(code[1])
					CORDELIA_OUT_COR_open.write(LINE_SEP)
					
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

		if CORDELIA_COMPILE_FIRST:
			csound_cordelia.compileOrc('\n'.join(CORDELIA_COMPILE_FIRST))
			CORDELIA_COMPILE_FIRST.clear()	

		if CORDELIA_COMPILE:
			csound_cordelia.compileOrcAsync('\n'.join(CORDELIA_COMPILE))
			CORDELIA_COMPILE.clear()

RECORD = True

record_init = True

if __name__ == '__main__':

	udp.open_ports()
	cs_return = csound_cordelia.start()
	pt = ctcsound.CsoundPerformanceThread(csound_cordelia.csound())
	t = Thread(target=main, daemon=True)

	if cs_return == ctcsound.CSOUND_SUCCESS:

		print('CSOUND is ON!')
		t.start()
		pt.play()

		while pt.status() == 0:	
			if RECORD and cordelia_init and record_init:
				print(f'RECORDING IS {cordelia_init}')
				pt.record(CORDELIA_OUT_RAW, 24, 2)
				record_init = False

		pt.stopRecord()


		#print('Record OFF')
		CORDELIA_OUT_LOG_open.close()
		CORDELIA_OUT_COR_open.close()

		if not record_init:
			tfm = sox.Transformer()
			min_silence_duration = 3.5
			#tfm.silence(1, .015, min_silence_duration, True)
			tfm.set_input_format(ignore_length=True)
			tfm.build(CORDELIA_OUT_RAW, CORDELIA_OUT_WAV)

		csound_cordelia.cleanup()
		print('CSOUND is OFF!')

	del csound_cordelia
	exit()
	