from utils.constants import CORDELIA_DIR

import re, subprocess

#return a string of which real time audio module: on macOS PortAudio or CoreAudio
def which_rtaudio():
	#define the regex
	match = '-+rtaudio='
	with open(f'{CORDELIA_DIR}/_core/option.orc') as f:
		for line in f:
			line = line.strip()
			#remove comments
			if not line.startswith(';') and line.startswith(match):
				return line

#run csound and retrive the adc & dac numbers
if which_rtaudio()!='-+rtaudio=jack':
	devices_now = subprocess.run(['csound', f'{which_rtaudio()}', '--devices'], capture_output=True, text=True).stderr.strip()
	print(devices_now)

def extract_device(input_string):
    start_index = input_string.find("(") + 1
    end_index = input_string.rfind(")") + 1
    return input_string[start_index:end_index]

def query_devices(converter):
	
	if which_rtaudio()!='-+rtaudio=jack':
		if converter == 'adc':
			string = 'input'
		elif converter == 'dac':
			string = 'output'

		#get a list of selected output
		devices = re.findall(rf'{converter}.*', devices_now, flags=re.MULTILINE)
		for i, each in enumerate(devices):
			print(each)
			devices[i] = extract_device(each).strip()
		
		res = []
		#print(devices)

		#ADC
		#iterate through the list text
		with open(f'{CORDELIA_DIR}/_setting/_{converter}') as f:
			for line in f:
				line = line.strip()
				#remove comments and blank
				if not line.startswith(';') and line:
					for device in devices:
						#check if starts with the name inside the list
						if device.startswith(line.split('--')[0]):
							res.extend([f'{string}={converter}{str(devices.index(device))}'])
							#add option eventually, everything but first (device name)
							res.extend(line.split('--')[1:])
							#concatenate the final dash --
							return ['--' + s for s in res]
	
	else:
		if converter == 'adc':
			return ['-iadc']
		elif converter == 'dac':
			return ['-odac']


