from config import cordelia_path
import re, subprocess
import ctcsound
from datetime import datetime 





#######################################
# CONSTANTs
#######################################

cordelia_date = datetime.today().strftime('%y%m%d-%H%M')

cordelia_out_wav = f'{cordelia_path}/_score/cor{cordelia_date}.wav'
cordelia_out_orc = f'{cordelia_path}/_score/cor{cordelia_date}.orc'
cordelia_out_mid = f'{cordelia_path}/_score/cor{cordelia_date}.mid'

cs = ctcsound.Csound()

#######################################
# FUNCTIONs
#######################################
#return a string of which real time audio module: on macOS PortAudio or CoreAudio
def which_rtaudio():
	#define the regex
	match = '-+rtaudio='
	with open(f'{cordelia_path}/_core/option.orc') as f:
		for line in f:
			line = line.strip()
			#remove comments
			if not line.startswith(';') and line.startswith(match):
				return line

#run csound and retrive the adc & dac numbers
devices_now = subprocess.run(['csound', f'{which_rtaudio()}', '--devices'], capture_output=True, text=True).stderr.strip()

def query_devices(converter):

	if converter == 'adc':
		string = 'input'
	elif converter == 'dac':
		string = 'output'

	#get a list of selected output
	devices = re.findall(rf'{converter}.*\((.*)\)', devices_now, re.MULTILINE)
	res = []

	#ADC
	#iterate through the list text
	with open(f'{cordelia_path}/_core/devices-{converter}.orc') as f:
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


#######################################
# CSOUND OPTIONs
#######################################
#put everything inside a list
opt =[]

with open(f'{cordelia_path}/_core/option.orc') as f:
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

with open(f'{cordelia_path}/_core/setting.orc') as f:
	cs.compileOrcAsync(f.read())

with open(f'{cordelia_path}/_core/cordelia.orc') as f:
	cs.compileOrcAsync(f.read())

#######################################
# CSOUND START
#######################################

cs_return = cs.start()
pt = ctcsound.CsoundPerformanceThread(cs.csound())

#filename = '/Users/j/Desktop/con.wav'
#bits = 24
#numbufs = 4096

if cs_return == ctcsound.CSOUND_SUCCESS:

	print('CSOUND is ON!')
	pt.play()
	
	#print('Record ON') 
	#pt.record(filename, bits, numbufs)

	while pt.status() == 0:
		#out_stream = cs.outputBuffer()
		#print(out_stream)
		pass
	
	#pt.stopRecord()
	#print('Record OFF')

	cs.cleanup()
	print('CSOUND is OFF!')

	del cs
	