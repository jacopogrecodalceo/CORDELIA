import ctcsound

from config.const_path import CORDELIA_DIR
from .csound_func import query_devices

csound_cordelia = ctcsound.Csound()

#######################################
# INIT CSOUND OPTIONs
#######################################
OPTIONs = []

with open(f'{CORDELIA_DIR}/_core/option.orc') as f:
	for line in f:
		line = line.strip()
		if line and not line.startswith(';'):
			OPTIONs.append(line)

OPTIONs.extend(query_devices('adc'))
OPTIONs.extend(query_devices('dac'))

for option in OPTIONs:
	csound_cordelia.setOption(option)
	print(option)

# csound_cordelia.setOption(f'--midioutfile={CORDELIA_OUT_MID}')
# csound_cordelia.setOption(f'--omacro:SCO_NAME="{CORDELIA_OUT_SCO}"')

#######################################
# CSOUND SETTINGS
#######################################
# csound_cordelia.setOption('-n')

SETTINGs = []
with open(f'{CORDELIA_DIR}/_core/setting.orc') as f:
	SETTINGs.append(f.read())

with open(f'{CORDELIA_DIR}/_core/include.orc') as f:
	SETTINGs.append(f.read())

for setting in SETTINGs:
	csound_cordelia.compileOrcAsync(setting)

CORDELIA_NCHNLS = csound_cordelia.nchnls()
print(f'Cordelia has {CORDELIA_NCHNLS} channels\n')

CORDELIA_SR = int(csound_cordelia.sr())
print(f'Cordelia has a sample rate of {CORDELIA_SR}\n')
