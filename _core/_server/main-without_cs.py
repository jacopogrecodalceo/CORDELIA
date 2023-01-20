#import from file
#import constants

import cordelia
import utils.udp as udp

#import utils.udp as udp
#udp.open_ports()
import pprint

code = """

FIRST_LINE

eu: "1501", 8
	+kv = .25 + abs:k(lfo:k(2, gkbeatf/64))
	+kp pump 3, fillarray(69, 68, 66)
	@irina_brochin@asd@jesuss.flingj(123, 23, 122 sfaklsdj).getnrkenfuc()
	gkbeats*kv
	accent(3, $fff)*9
	gilikearev$atk(5)
	cpstun(once(1, 2), 69+$once(0, 1), vitry)
	cpstun(once(1, 2), kp+$once(0, 1, 2), gi11_10ET)
	

eu: "1501", 8
	+kv = .25 + abs:k(lfo:k(2, gkbeatf/64))
	+kp pump 3, fillarray(69, 68, 66)
	@irina_brochin.flingj(123, 23, 122 sfaklsdj).getnrkenfuc()
	gkbeats*kv
	accent(3, $fff)*9
	gilikearev$atk(5)
	cpstun(once(1, 2), 69+$once(0, 1), vitry)
	cpstun(once(1, 2), kp+$once(0, 1, 2), gi11_10ET)

LAST_LINE

"""


def main(code):

	#separate units and first parsing
	#IMPORTANT HERE:
	# - filter the last used elements
	# - check if elements is in csound
	# - unit separation 
	print('---UNIFIER')
	units = cordelia.unifier(code)
	#print(units)
	for unit in units:
		#print(unit)
		pass

	#generate dict (tokens)
	#IMPORTANT HERE: 
	# - comment detection
	# - submodule opcodes
	print('---LEXER')
	#a list of dict
	tokens = cordelia.lexer(units)
	#print(tokens)
	for token in tokens:
		#print('---')
		#pprint.pprint(token)
		pass

	#update dict and creates rules
	#IMPORTANT HERE:
	# - filter the last used elements
	print('---RULER')
	ruled_tokens = cordelia.ruler(tokens)

	#format to csound
	print('---PARSER')
	cscodes = cordelia.parser(ruled_tokens)
	for cscode in cscodes:
			#print('---')
			print(cscode)
			pass



#---receive code
#---return a list of each unity in the code
#---inside send also GEN and SCALA if they're not already used
#unifier =  cordelia.Unifier()

#---receive a list of unity
#---return a list of tokens for each unity
#lexer = cordelia.Lexer()

#---receive a list of tokens
#---return code formatted for csound
#---transform tokens to csound
#parser = cordelia.Parser()

#send to csound

#units = unifier(code)
#tokens = lexer(units)
#code = parser(tokens)

if __name__ == '__main__':
	udp.open_ports()
	
	while True:
		try:
			code = udp.receive_messages()
			main(code)
		except KeyboardInterrupt: 
			break
