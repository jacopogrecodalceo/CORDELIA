import ctcsound
import subprocess
import re, os

from constants.var import cordelia_date, cordelia_given_instr
from constants.path import cordelia_score
from src.read_config import Main_config

def remember(instrument_name):

	instr_add = (len(cordelia_given_instr))/10000
	instr_setting = f'schedule {round(945+instr_add, 5)}, 0, -1, "{instrument_name}", "{cordelia_score}/cor{cordelia_date}-{instrument_name}.wav"\n'
	return instr_setting

def csound_clear_instrument(instrument_name):
	
	instr_setting = []
	start = cordelia_nchnls * (len(cordelia_given_instr) - 1) + 1
	sequence = [start + i for i in range(cordelia_nchnls)]
	for index, val in enumerate(sequence):
		instr_num = 950 + (val/10000)
		instr_setting.append(f'schedule {round(instr_num, 5)}, 0, -1, "{instrument_name}_{index+1}"')
	return instr_setting

def create_dir(directory):
	# Check if the directory doesn't exist, then create it
	if not os.path.exists(directory):
		os.mkdir(directory)
		print(f"Directory '{directory}' created successfully.")
	else:
		print(f"Directory '{directory}' already exists.")

# Extract the device name from the input string
def extract_device(input_string):
	start_index = input_string.find("(") + 1
	end_index = input_string.rfind(")") + 1
	return input_string[start_index:end_index]

# Return the real-time audio module: 'PortAudio' or 'CoreAudio' on macOS
def which_rtaudio():
	match = '-+rtaudio='
	with open('./csound_cordelia/option.orc') as f:
		for line in f:
			line = line.strip()
			if not line.startswith(';') and line.startswith(match):
				return line

# Get the list of devices and their details
def get_devices():
	if which_rtaudio() != '-+rtaudio=jack':
		output = subprocess.run(['/usr/local/bin/csound', f'{which_rtaudio()}', '--devices'], capture_output=True, text=True).stderr.strip()
		devices = re.findall(r'adc.*|dac.*', output, flags=re.MULTILINE)
		return [device for device in devices]
	return []

def process_line(line, converter, devices, options):
	for device in devices:
		if line in device:
			match = re.match(fr'{converter}\d+', device)
			if match:
				code = match.group(0)
				string = f'-i{code}' if converter == 'adc' else f'-o{code}'
				line_and_options = line.strip().split('--')
				if len(line_and_options) > 1:
					for opt in line_and_options[1:]:
						options.append(f'--{opt}')
				options.append(string)
				devices.remove(device)
				return True  # Return True if a match is found
	return False  # Return False if no match is found



# Query devices and construct the appropriate OPTIONs for ADC or DAC
def query_devices():
	devices = get_devices()
	if not devices:
		print('Warning, no devices used - PROBABLY JACK USED?')

	options = []

	for converter in ['adc', 'dac']:
		with open(f'./default/{converter}') as f:
			for line in f.readlines():
				line_and_options = line.strip().split('--')
				line = line_and_options[0]
				if line and not line.startswith(';'):
					match_found = False  # Flag to track if a match has been found
					for device in devices:
						if line in device:
							match = re.match(fr'{converter}\d+', device)
							if match:
								code = match.group(0)
								string = f'-i{code}' if converter == 'adc' else f'-o{code}'
								if len(line_and_options) > 1:
									for opt in line_and_options[1:]:
										options.append(f'--{opt}')
								options.append(string)
								devices.remove(device)
								match_found = True  # Set the flag to True if a match is found
								break
					if match_found:
						break 

	return options if options else ['-odac', 'iadc']

def init_csound():
	OPTIONs = []

	with open('./csound_cordelia/option.orc') as f:
		for line in f:
			line = line.strip()
			if line and not line.startswith(';'):
				OPTIONs.append(line)
	
	OPTIONs.extend(query_devices())
	OPTIONs.append(f'--nchnls={CORDELIA_CONFIG.nchnls}')

	for option in OPTIONs:
		csound_cordelia.setOption(option)
		print(option)

	SETTINGs = []
	SETTINGs.append(f'ginchnls init {CORDELIA_CONFIG.csound_audio_array_count}')
	with open('./csound_cordelia/setting.orc') as f:
		SETTINGs.append(f.read())

	with open('./csound_cordelia/include.orc') as f:
		SETTINGs.append(f.read())

	csound_cordelia.compileOrcAsync('\n'.join(SETTINGs))
	print('\n'.join(SETTINGs))
#######################################
# INIT CSOUND OPTIONs
#######################################
ctcsound.csoundInitialize(ctcsound.CSOUNDINIT_NO_ATEXIT | ctcsound.CSOUNDINIT_NO_SIGNAL_HANDLER)
csound_cordelia = ctcsound.Csound()

CORDELIA_CONFIG = Main_config()

init_csound()

cordelia_nchnls = CORDELIA_CONFIG.csound_audio_array_count
print(f'Cordelia has {cordelia_nchnls} channels\n')

cordelia_sr = int(csound_cordelia.sr())
print(f'Cordelia has a sample rate of {cordelia_sr}\n')

cordelia_ksmps = int(csound_cordelia.ksmps())
print(f'Cordelia has {cordelia_ksmps} ksmps\n')
