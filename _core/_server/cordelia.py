from threading import Thread
import time, pprint

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

			#list of class instrument
			instruments = cordelia.parser(code[1])

			#list of string instrument and vars
			contents = cordelia.content(instruments)

			contents_filtered = cordelia.filter(contents)
			wrapped_instruments = cordelia.wrapper(contents_filtered)	
			for each in wrapped_instruments:
					print(each)
					print(LINE_SEP)
					CORDELIA_COMPILE.append(each)
		
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

RECORD = False

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
	