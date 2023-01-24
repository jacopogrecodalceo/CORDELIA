import re

#---receive code
#---return a list of each unity in the code
#unifier =  cordelia.Unifier()

def unifier(raw_code) -> list():

	#added for regex parse
	raw_code += '\n'

	#delete all $ symbol for macros
	raw_code = re.sub(r'\$', '', raw_code, flags=re.MULTILINE)

	#find all unit by new line and separate them 
	units = re.findall(r'^(.(?:\n|.)*?)\n$', raw_code, flags=re.MULTILINE)

	return units
