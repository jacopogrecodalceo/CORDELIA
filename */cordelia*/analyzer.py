import cordelia.preconvert
from utils.constants import bcolors

#---inside send also GEN and SCALA if they're not already used
#unifier =  cordelia.Unifier()

def analyzer(unit) -> str():

	#check if the first line is commented - quicker way to mute instrument
	if not unit.startswith(';'):

		try:
			
			unit = cordelia.preconvert.note(unit)
			unit = cordelia.preconvert.macro(unit)
			unit = cordelia.preconvert.abbr(unit)
			unit = cordelia.preconvert.scala(unit)
			unit = cordelia.preconvert.gen(unit)
			unit = cordelia.preconvert.instr(unit)
			
		except Exception as e:
			print(f'This is an {bcolors.WARNING}exception{bcolors.ENDC}')
			print(f'Check this: {bcolors.WARNING}{e}{bcolors.ENDC}, are you sure it exists?')

	return unit