import cordelia
import utils.udp as udp
from utils.constants import LINE_SEP
from csound import csound_cordelia, ctcsound

def main(code):

	print('---UNIFIER')
	units = cordelia.unifier(code)

	instruments = []
	for preunit in units:

		print('---ANALYZER')
		unit = cordelia.analyzer(preunit)

		print('---LEXER')
		pre_instrument = cordelia.lexer(unit)

		print('---EXTRACTER')
		instrument_e = cordelia.extracter(pre_instrument)
		for i in instrument_e:
			#print(i)
			instruments.append(i)

	instruments_f = cordelia.filter(instruments)
	for index, i in enumerate(instruments_f):
		instruments_i = cordelia.wrapper(index, i)
		print(instruments_i)
		print(LINE_SEP)
		csound_cordelia.compileOrcAsync(instruments_i)

if __name__ == '__main__':

	udp.open_ports()
	cs_return = csound_cordelia.start()
	pt = ctcsound.CsoundPerformanceThread(csound_cordelia.csound())

	if cs_return == ctcsound.CSOUND_SUCCESS:

		print('CSOUND is ON!')
		pt.play()
		
		while pt.status() == 0:
			code = udp.receive_messages()
			main(code)

		#pt.stopRecord()
		#print('Record OFF')
		csound_cordelia.cleanup()
		print('CSOUND is OFF!')

		del csound_cordelia
	