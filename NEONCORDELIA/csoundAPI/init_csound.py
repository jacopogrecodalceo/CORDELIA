import ctcsound

from config.const_path import CORDELIA_DIR, CORDELIA_OUT_SCO, CORDELIA_OUT_CSV, CORDELIA_OUT_MID, CORDELIA_OUT_CSCORE
from config.const import DATE

csound_cordelia = ctcsound.Csound()

import re
import subprocess

# Return the real-time audio module: 'PortAudio' or 'CoreAudio' on macOS
def which_rtaudio():
	match = '-+rtaudio='
	with open(f'{CORDELIA_DIR}/_core/option.orc') as f:
		for line in f:
			line = line.strip()
			if not line.startswith(';') and line.startswith(match):
				return line

# Get the list of devices and their details
def get_devices():
	if which_rtaudio() != '-+rtaudio=jack':
		output = subprocess.run(['csound', f'{which_rtaudio()}', '--devices'], capture_output=True, text=True).stderr.strip()
		devices = re.findall(r'adc.*|dac.*', output, flags=re.MULTILINE)
		return [extract_device(device).strip() for device in devices]
	return []

# Extract the device name from the input string
def extract_device(input_string):
	start_index = input_string.find("(") + 1
	end_index = input_string.rfind(")") + 1
	return input_string[start_index:end_index]

# Query devices and construct the appropriate options for ADC or DAC
def query_devices(converter):
	devices = get_devices()
	if not devices:
		return []

	if converter == 'adc':
		string = 'input'
	elif converter == 'dac':
		string = 'output'

	options = []
	with open(f'{CORDELIA_DIR}/_setting/_{converter}') as f:
		for line in f:
			line = line.strip()
			if line and not line.startswith(';'):
				for device in devices:
					if device.startswith(line.split('--')[0]):
						res = [f'{string}={converter}{str(devices.index(device))}']
						res.extend(line.split('--')[1:])
						options.extend(['--' + s for s in res])
						return options

	if converter == 'adc':
		return ['-iadc']
	elif converter == 'dac':
		return ['-odac']
	return []


#######################################
# CSOUND OPTIONS
#######################################
options = []

with open(f'{CORDELIA_DIR}/_core/option.orc') as f:
	for line in f:
		line = line.strip()
		if line and not line.startswith(';'):
			options.append(line)

options.extend(query_devices('adc'))
options.extend(query_devices('dac'))

for option in options:
	csound_cordelia.setOption(option)
	print(option)

# csound_cordelia.setOption(f'--midioutfile={CORDELIA_OUT_MID}')
# csound_cordelia.setOption(f'--omacro:SCO_NAME="{CORDELIA_OUT_SCO}"')

#######################################
# CSOUND SETTINGS
#######################################
# csound_cordelia.setOption('-n')

with open(f'{CORDELIA_DIR}/_core/setting.orc') as f:
	csound_cordelia.compileOrcAsync(f.read())

with open(f'{CORDELIA_DIR}/_core/include.orc') as f:
	csound_cordelia.compileOrcAsync(f.read())

csound_cordelia.compileOrcAsync(f'gScsound_score init "{CORDELIA_OUT_CSCORE}"')

CORDELIA_NCHNLS = csound_cordelia.nchnls()
print(f'I have {CORDELIA_NCHNLS} channels\n')

CORDELIA_SR = csound_cordelia.sr()
