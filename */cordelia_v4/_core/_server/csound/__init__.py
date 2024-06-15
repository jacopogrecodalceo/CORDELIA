import ctcsound

from utils.constants import CORDELIA_DIR, CORDELIA_OUT_SCO, CORDELIA_OUT_CSV, CORDELIA_OUT_MID, CORDELIA_DATE, CORDELIA_OUT_CSCORE
from csound.init_csound import *

csound_cordelia = ctcsound.Csound()

#######################################
# CSOUND OPTIONs
#######################################
#put everything inside a list
opt =[]

with open(f'{CORDELIA_DIR}/_core/option.orc') as f:
	for line in f:
		line = line.strip()
		if not line.startswith(';') and line:
			opt.append(line)


opt.extend(query_devices('adc'))
opt.extend(query_devices('dac'))

#and then iterate it!
for o in opt:
	csound_cordelia.setOption(o)
	print(o)

#csound_cordelia.setOption(f'--midioutfile={CORDELIA_OUT_MID}')

#csound_cordelia.setOption(f'--omacro:SCO_NAME="{CORDELIA_OUT_SCO}"')

#######################################
# CSOUND SETTING
#######################################
#csound_cordelia.setOption('-n')


with open(f'{CORDELIA_DIR}/_core/setting.orc') as f:
	csound_cordelia.compileOrcAsync(f.read())

with open(f'{CORDELIA_DIR}/_core/include.orc') as f:
	csound_cordelia.compileOrcAsync(f.read())

csound_cordelia.compileOrcAsync(f'gScsound_score init "{CORDELIA_OUT_CSCORE}"')


CORDELIA_NCHNLS = csound_cordelia.nchnls()
print(f'I have {CORDELIA_NCHNLS} channels\n')

CORDELIA_SR = csound_cordelia.sr()
