import ctcsound

from utils.constants import CORDELIA_DIR
from csound.init_csound import *

cs = ctcsound.Csound()

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
	cs.setOption(o)
	print(o)

#######################################
# CSOUND SETTING
#######################################

with open(f'{CORDELIA_DIR}/_core/setting.orc') as f:
	cs.compileOrcAsync(f.read())

with open(f'{CORDELIA_DIR}/_core/cordelia.orc') as f:
	cs.compileOrcAsync(f.read())