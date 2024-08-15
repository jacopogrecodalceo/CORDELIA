import ctcsound
import sox
import os, sys
import time
import re
from datetime import datetime
import logging

# Path to the directory containing the sox executable
homebrew_directory = '/opt/homebrew/bin'

# Modify the PATH environment variable
os.environ['PATH'] = f"{homebrew_directory}:{os.environ['PATH']}"

logging.basicConfig(filename='/Users/j/cordelia-script.log', level=logging.DEBUG, filemode='w')

logging.info('Script execution path: %s', os.path.abspath(__file__))
current_date = datetime.now()
formatted_date = current_date.strftime("%d %B %Y, %H:%M:%S")
logging.info(formatted_date)

REMOVE_FILEs = True

def extract_score_data(string):
	pattern = r'/\*([\s\S]*?)\*/'
	matches = re.findall(pattern, string)

	if matches:
		return matches[0].strip()
	else:
		return None

ctcsound.csoundInitialize(ctcsound.CSOUNDINIT_NO_ATEXIT | ctcsound.CSOUNDINIT_NO_SIGNAL_HANDLER)

cs = ctcsound.Csound()
cs.createMessageBuffer(False)

input_file_wav = sys.argv[1]
input_file_orc = sys.argv[2]
output_file_wav = sys.argv[3]

basename = os.path.splitext(os.path.basename(input_file_wav))[0]

channels = sox.file_info.channels(input_file_wav)
sample_rate = sox.file_info.sample_rate(input_file_wav)

#output_tempdir = os.path.dirname(file)
output_tempdir = '/Users/j/Documents/temp/'

log_file = output_file_wav + '.log'

pvs_files = []
mono_files = []

channels = sox.file_info.channels(input_file_wav)
for i in range(1, channels+1):
	tfm = sox.Transformer()
	output_file = os.path.join(output_tempdir, basename + f'-{i}ch.wav')
	logging.info(f'Writing {i} channel of {basename} to {output_file}')
	tfm.remix(remix_dictionary={1: [i]}, num_output_channels=1)
	tfm.build(input_filepath=input_file_wav, output_filepath=output_file)
	mono_files.append(output_file)

for f in mono_files:
	pvs_files.append(f + '.pvx')

mono_files_code = ['"' + f + '"' for f in mono_files]
orc_code = f'gSfiles[] fillarray {", ".join(mono_files_code)}\n'

with open(input_file_orc, 'r') as f:
	orc_code += f.read()
	if 'gScsound_score' in orc_code:
		output_file = output_file_wav + '.sco'
		string = f'gScsound_score init "{output_file}"\n'
		orc_code = string + orc_code

	sco_python_code = extract_score_data(orc_code)

logging.info(orc_code)

score = []
if sco_python_code is not None:
	try:
		for ch in range(channels):
			exec(sco_python_code)
	except Exception as e:
		logging.info("Error executing the code:", str(e))

score.append('e')
score = '\n'.join(score)
logging.info(score)

# Set Csound options
cs.setOption(f'-o{output_file_wav}')
#cs.setOption(f'--sample-rate=48000')
cs.setOption(f'-3')
#cs.setOption(f'--ksmps={ksmps}')
cs.setOption(f'--0dbfs=1')
#cs.setOption(f'--nchnls={channels}')


cs.compileOrc(orc_code)
cs.readScore(score)

cs.start()
with open(log_file, 'a') as f:
	while cs.performKsmps() == 0:
		string = cs.firstMessage()
		# Set the custom performance callback
		if string:
			f.write(string)
		cs.popFirstMessage()
	
cs.cleanup()
cs.destroyMessageBuffer()
del cs

time.sleep(1/8)

with open(output_file_wav + '--finished', 'w') as f:
	f.write('I EXIST')

try:

	# Remove the file
	with open(input_file_orc, 'w') as f:
		f.write(orc_code)

	if REMOVE_FILEs:
		os.remove(input_file_wav)
		for f in mono_files:
			os.remove(f)
		for f in pvs_files:
			os.remove(f.replace('"', ''))

	logging.info("File removed successfully.")
except FileNotFoundError:
	logging.info("File not found.")
except Exception as e:
	logging.info("Error removing the file:", str(e))
