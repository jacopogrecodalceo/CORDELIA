import ctcsound
import sox
import os, sys
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

channels = sox.file_info.channels(input_file_wav)
sample_rate = sox.file_info.sample_rate(input_file_wav)

#output_tempdir = os.path.dirname(file)
output_tempdir = '/Users/j/Documents/PROJECTs/_temp'

lpc_files = []
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
	lpc_files.append(f + '.lpc')

mono_files_code = ['"' + f + '"' for f in mono_files]
orc_code = f'gSfiles[] fillarray {", ".join(mono_files_code)}\n'

with open(input_file_orc, 'r') as f:
	orc_code += f.read()
	sco_python_code = extract_score_data(orc_code)

print(orc_code)

score = []
if sco_python_code is not None:
	try:
		for ch in range(channels):
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
	for f in lpc_files:
		os.remove(f.replace('"', ''))

	print("File removed successfully.")
except FileNotFoundError:
	print("File not found.")
except Exception as e:
	print("Error removing the file:", str(e))
