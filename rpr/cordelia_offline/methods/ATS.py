import ctcsound
import os
import sys
import subprocess
import time
import re
import concurrent.futures
import soundfile as sf

from datetime import datetime
import logging

from _func import *

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

def run_atsa(command):
	try:
		process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		stdout, stderr = process.communicate()
		if process.returncode != 0:
			logging.error(f"{stderr.decode('utf-8')}")
		else:
			logging.info(f'Csound processing {input_file} completed successfully.')
	except subprocess.CalledProcessError as e:
		return f"Error running command: {command}\n{e.stderr.strip()}"
	
ctcsound.csoundInitialize(ctcsound.CSOUNDINIT_NO_ATEXIT | ctcsound.CSOUNDINIT_NO_SIGNAL_HANDLER)
cs = ctcsound.Csound()
cs.createMessageBuffer(False)

input_file_wav = sys.argv[1]
input_file_orc = sys.argv[2]
output_file_wav = sys.argv[3]

basename = os.path.splitext(os.path.basename(input_file_wav))[0]

#output_tempdir = os.path.dirname(file)
output_tempdir = '/Users/j/Documents/temp/'

log_file = output_file_wav + '.log'

with open(input_file_orc, 'r') as f:
	orc_code = f.read()
	sco_python_code = extract_score_data(orc_code)

logging.info(orc_code)

ats_files = []
mono_files = create_mono_files(input_file_wav, basename, output_tempdir)

csound_commands = []
for f in mono_files:
	input_file = f
	output_file = os.path.join(output_tempdir, f'{os.path.splitext(os.path.basename(input_file))[0]}.ats')
	csound_commands.append(['/usr/local/bin/atsa', input_file, output_file])

with concurrent.futures.ThreadPoolExecutor() as executor:
	# Using a list comprehension to start all commands concurrently.
	# This returns a list of futures.
	futures = [executor.submit(run_atsa, command) for command in csound_commands]

	# Wait for all the commands to finish and retrieve the results.
	[future.result() for future in concurrent.futures.as_completed(futures)]


for f in os.listdir(output_tempdir):
	if f.endswith('.ats') and basename in f:
		ats_files.append('"' + os.path.join(output_tempdir, f) + '"')

score = []
if sco_python_code is not None:
	try:
		for i, ats_file in enumerate(ats_files):
			ch = int(re.findall(r'(\d+)ch', ats_file)[-1])
			exec(sco_python_code)
	except Exception as e:
		logging.error("Error executing the code:", str(e))

score.append('e')
score = '\n'.join(score)
logging.info(score)

# Set Csound options
cs.setOption(f'-o{output_file_wav}')
cs.setOption(f'-3')
cs.setOption(f'--0dbfs=1')

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
	with open(input_file_orc, 'w') as f:
		f.write(orc_code)
	if REMOVE_FILEs:
		# Remove the file
		os.remove(input_file_wav)
		for f in mono_files:
			os.remove(f)
		for f in ats_files:
			os.remove(f.replace('"', ''))

	logging.info("File removed successfully.")
except FileNotFoundError:
	logging.error("File not found.")
except Exception as e:
	logging.error("Error removing the file:", str(e))

logging.info('Script end: %s', os.path.abspath(__file__))
