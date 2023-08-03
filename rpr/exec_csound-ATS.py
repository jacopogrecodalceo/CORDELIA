import ctcsound
import sox
import os, sys
import subprocess
import time
import re

def extract_score_data(string):
	pattern = r'/\*([\s\S]*?)\*/'
	matches = re.findall(pattern, string)

	if matches:
		return matches[0].strip()
	else:
		return None

cs = ctcsound.Csound()

input_file_wav = sys.argv[1]
input_file_orc = sys.argv[2]
output_file_wav = sys.argv[3]

basename = os.path.splitext(os.path.basename(input_file_wav))[0]

ksmps = 16
channels = sox.file_info.channels(input_file_wav)
sample_rate = sox.file_info.sample_rate(input_file_wav)

#output_tempdir = os.path.dirname(file)
output_tempdir = '/Users/j/Documents/PROJECTs/_temp'



with open(input_file_orc, 'r') as f:
	orc_code = f.read()
	sco_python_code = extract_score_data(orc_code)

print(orc_code)

ats_files = []
mono_files = []

channels = sox.file_info.channels(input_file_wav)
for i in range(1, channels+1):
	tfm = sox.Transformer()
	output_file = os.path.join(output_tempdir, basename + f'-{i}ch.wav')
	print(f'Writing {i} channel of {basename} to {output_file}')
	tfm.remix(remix_dictionary={1: [i]}, num_output_channels=1)
	tfm.build(input_filepath=input_file_wav, output_filepath=output_file)
	mono_files.append(output_file)

for f in mono_files:
	input_file = f
	output_file = os.path.join(output_tempdir, f'{os.path.splitext(os.path.basename(input_file))[0]}.ats')
	csound_command = ['atsa', input_file, output_file]
	process = subprocess.Popen(csound_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	stdout, stderr = process.communicate()
	if process.returncode != 0:
		print(f"An error occurred: {stderr.decode('utf-8')}")
	else:
		print(f'Csound processing {input_file} completed successfully.')

for f in os.listdir(output_tempdir):
	if f.endswith('.ats') and basename in f:
		ats_files.append('"' + os.path.join(output_tempdir, f) + '"')

score = []
if sco_python_code is not None:
	try:
		for i, ats_file in enumerate(ats_files):
			ch = int(re.search(r'(\d+)ch', ats_file)[1])
			exec(sco_python_code)
	except Exception as e:
		print("Error executing the code:", str(e))

score.append('e')
score = '\n'.join(score)
print(score)

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
cs.perform()
cs.cleanup()
del cs

time.sleep(1/8)

with open(output_file_wav + '--finished', 'w') as f:
	f.write('I EXIST')

try:
	# Remove the file
	
	os.remove(input_file_wav)
	with open(input_file_orc, 'w') as f:
		f.write(orc_code)
	for f in mono_files:
		os.remove(f)
	for f in ats_files:
		os.remove(f.replace('"', ''))

	print("File removed successfully.")
except FileNotFoundError:
	print("File not found.")
except Exception as e:
	print("Error removing the file:", str(e))
