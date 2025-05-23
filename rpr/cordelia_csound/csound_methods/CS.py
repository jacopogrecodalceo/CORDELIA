import os, sys
import time
import re
import soundfile as sf
from datetime import datetime
import logging
import subprocess

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

input_file_wav = sys.argv[1]
input_file_orc = sys.argv[2]
output_file_wav = sys.argv[3]

basename = os.path.splitext(os.path.basename(input_file_wav))[0]

with sf.SoundFile(input_file_wav) as f:
    channels = f.channels

#output_tempdir = os.path.dirname(file)
output_tempdir = '/Users/j/Documents/temp/'
csound_sco_path = os.path.join(output_tempdir, f'{basename}.sco')
csound_orc_path = os.path.join(output_tempdir, f'{basename}-processed.orc')
log_file = output_file_wav + '.log'

orc_code = f'gSfile init "{input_file_wav}"\n'

with open(input_file_orc, 'r') as f:
	orc_code += f.read()
	sco_python_code = extract_score_data(orc_code)

logging.info(orc_code)

score = []
if sco_python_code is not None:
	try:
		logging.info(sco_python_code)
		for ch in range(channels):
			ch += 1
			exec(sco_python_code)
	except Exception as e:
		logging.info("Error executing the code:", str(e))

score.append('e')

with open(csound_sco_path, 'w') as f:
	f.write('\n'.join(score))
with open(csound_orc_path, 'w') as f:
	f.write(orc_code)

#csound [flags] [orchname] [scorename]

CSOUND_FLAGs = [
	f'-o{output_file_wav}',
	'--format=24bit',
	'--0dbfs=1',
]

csound_command = [
    '/usr/local/bin/csound',
    *CSOUND_FLAGs,
    csound_orc_path,
    csound_sco_path,
]

# Use subprocess to launch the command and wait until it completes
try:
    result = subprocess.run(csound_command, check=True, capture_output=True, text=True)
    logging.info('Csound finished successfully')
    if result.stdout:
        logging.debug(f'Csound output: {result.stdout}')
except subprocess.CalledProcessError as e:
    logging.error(f'Csound failed with error: {e.stderr}')
except FileNotFoundError:
    logging.error('Csound command not found. Is Csound installed and in your PATH?')

time.sleep(1/8)

with open(output_file_wav + '--finished', 'w') as f:
	f.write('I EXIST')

try:
	# Remove the file
	with open(input_file_orc, 'w') as f:
		f.write(orc_code)
	if REMOVE_FILEs:
		os.remove(input_file_wav)

	logging.info("File removed successfully.")
except FileNotFoundError:
	logging.info("File not found.")
except Exception as e:
	logging.info("Error removing the file:", str(e))
