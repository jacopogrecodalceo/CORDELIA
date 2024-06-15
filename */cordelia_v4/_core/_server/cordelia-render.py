import sys

import cordelia
from utils.constants import LINE_SEP
from csound import csound_cordelia, ctcsound

from utils.constants import CORDELIA_COMPILE, CORDELIA_OUT_WAV, CORDELIA_OUT_MID

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
		if instruments_i:
			print(instruments_i)
			print(LINE_SEP)
			#csound_cordelia.compileOrcAsync(instruments_i)
			CORDELIA_COMPILE.append(instruments_i)

	if CORDELIA_COMPILE:

		all_instr = []
		for i in range(len(instruments_f)-1):
			all_instr.append(f'turnoff2 {500+i}, 0, 1')
		ending = f'''
instr 	765
klast	init -1
prints "RENDER IS ALIVE\\n"
if chnget:k("heart") < klast then
{chr(10).join(all_instr)}
event "e", 0, 10
printks "RENDER DIEs\\n", 1
turnoff
endif
klast	= chnget:k("heart")
endin
schedule 765, 1, -1'''
		CORDELIA_COMPILE.append(ending)
		csound_cordelia.compileOrc('\n'.join(CORDELIA_COMPILE))
		CORDELIA_COMPILE.clear()
	

if __name__ == '__main__':

	csound_cordelia.setOption('--ksmps=4096')
	csound_cordelia.setOption(f'-o{CORDELIA_OUT_WAV}')
	csound_cordelia.setOption(f'--midioutfile={CORDELIA_OUT_MID}')

	corfile = sys.argv[1]

	with open(corfile, 'r') as f:
		code = f.read()

	cs_return = csound_cordelia.start()
	pt = ctcsound.CsoundPerformanceThread(csound_cordelia.csound())

	if cs_return == ctcsound.CSOUND_SUCCESS:

		print('CSOUND is ON!')
		pt.play()
		main(code)

		while pt.status() == 0:
			pass

		#print('Record OFF')
		csound_cordelia.cleanup()
		print('CSOUND is OFF!')

	del csound_cordelia
	exit()
	