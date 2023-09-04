import subprocess, re

from config.const_path import CORDELIA_DIR

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

# Query devices and construct the appropriate OPTIONs for ADC or DAC
def query_devices(converter):
	devices = get_devices()
	if not devices:
		return []

	if converter == 'adc':
		string = 'input'
	elif converter == 'dac':
		string = 'output'

	OPTIONs = []
	with open(f'{CORDELIA_DIR}/_setting/_{converter}') as f:
		for line in f:
			line = line.strip()
			if line and not line.startswith(';'):
				for device in devices:
					if device.startswith(line.split('--')[0]):
						res = [f'{string}={converter}{str(devices.index(device))}']
						res.extend(line.split('--')[1:])
						OPTIONs.extend(['--' + s for s in res])
						return OPTIONs

	if converter == 'adc':
		return ['-iadc']
	elif converter == 'dac':
		return ['-odac']
	return []

