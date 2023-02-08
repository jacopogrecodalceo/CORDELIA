from threading import Thread
import time


import cordelia
import utils.udp as udp
from utils.constants import LINE_SEP
from utils.misc import count_time
from csound import csound_cordelia, ctcsound

from utils.constants import CORDELIA_COMPILE, CORDELIA_OUT_WAV



def main():

	while True:
		code = udp.receive_messages()

		if code[0] == 'BRAIN':
			start_time = time.time()

			print('---UNIFIER')
			units = cordelia.unifier(code[1])
			#count_time(start_time)

			instruments = []
			for preunit in units:

				print('---ANALYZER')
				unit = cordelia.analyzer(preunit)
				#count_time(start_time)

				print('---LEXER')
				pre_instrument = cordelia.lexer(unit)
				#count_time(start_time)

				print('---EXTRACTER')
				instrument_e = cordelia.extracter(pre_instrument)
				for i in instrument_e:
					#print(i)
					instruments.append(i)
				#count_time(start_time)

			instruments_f = cordelia.filter(instruments)
			#count_time(start_time)
			for index, i in enumerate(instruments_f):
				instruments_i = cordelia.wrapper(index, i)
				if instruments_i:
					print(instruments_i)
					print(LINE_SEP)
					#csound_cordelia.compileOrcAsync(instruments_i)
					CORDELIA_COMPILE.append(instruments_i)
			
			#count_time(start_time)
		
		elif code[0] == 'REAPER':
			if code[1]:
				unit = cordelia.analyzer(code[1])
				unit = unit.replace('@', '')
				print(unit)
				#csound_cordelia.compileOrcAsync(unit)
				CORDELIA_COMPILE.append(unit)

		elif code[0] == 'CSOUND':
			if code[1]:
				print(code[1])
				#csound_cordelia.compileOrcAsync(code[1])
				CORDELIA_COMPILE.append(code[1])

		if CORDELIA_COMPILE:
			csound_cordelia.compileOrcAsync('\n'.join(CORDELIA_COMPILE))
			CORDELIA_COMPILE.clear()

RECORD = True

if __name__ == '__main__':

	udp.open_ports()
	cs_return = csound_cordelia.start()
	pt = ctcsound.CsoundPerformanceThread(csound_cordelia.csound())
	t = Thread(target=main, daemon=True)

	if cs_return == ctcsound.CSOUND_SUCCESS:

		print('CSOUND is ON!')
		t.start()
		pt.play()

		if RECORD:
			pt.record(CORDELIA_OUT_WAV, 24, 32)

		while pt.status() == 0:	
			pass

		if RECORD:
			pt.stopRecord()


		#print('Record OFF')
		csound_cordelia.cleanup()
		print('CSOUND is OFF!')

	del csound_cordelia
	exit()
	