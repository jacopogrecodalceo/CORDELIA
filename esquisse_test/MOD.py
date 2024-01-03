import ctcsound

import re
import os

PATH = '/Users/j/Documents/PROJECTs/CORDELIA/_MOD'
NAME = 'pitchebij'

SAMPLE = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm1.wav'

OPTIONs = [
	'-odac0',
	'--sample-rate=48000',
	'--ksmps=64',
	'--nchnls=2',
	'--0dbfs=1',
	'--limiter'
]

CSOUND_CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIA/_cordelia/csound_cordelia'
INCLUDEs = [
	'1-character',
	'2-head',
	'3-body'
]

def init_csound(cs):
	for option in OPTIONs:
		cs.setOption(option)
		print(option)

def get_includes_orc():
	orc_list = []
	for include in INCLUDEs:
		for root, dirs, files in os.walk(os.path.join(CSOUND_CORDELIA_DIR, include)):
			for file in files:
				if file.endswith('orc'):
					path = os.path.join(root, file)
					include_string = f'#include "{path}"'
					orc_list.append(include_string)
	orc_list.sort()
	res = '\n'.join(orc_list)
	print(res)
	return res


def get_opcode_definition():
	with open(os.path.join(PATH, NAME + '.orc'), 'r') as f:
		input_string = f.read()

		opcode_core = re.search(r';START CORE(.*?)\;END CORE', input_string, re.DOTALL)
		if opcode_core:
			print(opcode_core.group(1).strip())

		opcode_def = re.search(r';START OPCODE(.*?)\;END OPCODE', input_string, re.DOTALL)
		if opcode_def:
			return opcode_def.group(1).strip()

ORC = f'''
ginchnls	init nchnls		;e.g. click track
gioffch		init 0		;e.g. I want to go out in 3, 4

gimainclock_ch init 5
giquarterclock_ch init 6

gisend_freq1_ch	init 7 
gisend_freq2_ch	init 8

gieva_memories init 0
{get_includes_orc()}

{get_opcode_definition()}

	instr 1

ain, a_ diskin2 "{SAMPLE}"

aout cordelia_pitch_chebyshev ain, 4, 0, 1

	outall aout;+ain/128

	endin
'''

SCO = '''
i1 0 50
'''

if __name__ == "__main__":
	ctcsound.csoundInitialize(ctcsound.CSOUNDINIT_NO_ATEXIT | ctcsound.CSOUNDINIT_NO_SIGNAL_HANDLER)
	cs = ctcsound.Csound()
	init_csound(cs)

	cs.compileOrc(ORC)
	cs.readScore(SCO)

	cs.start()
	cs.perform()
	cs.cleanup()
	cs.reset()
	del cs