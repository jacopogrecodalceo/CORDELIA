import ctcsound
import pprint

import utils.udp as udp
import cordelia
from csound import cs

def main(code):

	print('---UNIFIER')
	units = cordelia.unifier(code)
	#print(units)
	for unit in units:
		#print(unit)
		pass
	
	print('---LEXER')
	#a list of dict
	tokens = cordelia.lexer(units)
	#print(tokens)
	for token in tokens:
		#print('---')
		pprint.pprint(token)
		pass

	print('---PARSER')
	cscode = cordelia.parser(tokens)

if __name__ == '__main__':

    udp.open_ports()
    cs_return = cs.start()
    pt = ctcsound.CsoundPerformanceThread(cs.csound())

    if cs_return == ctcsound.CSOUND_SUCCESS:

        print('CSOUND is ON!')
        pt.play()
        while pt.status() == 0:
            code = udp.receive_messages()
            main(code)

        #pt.stopRecord()
        #print('Record OFF')
        cs.cleanup()
        print('CSOUND is OFF!')

        del cs
	