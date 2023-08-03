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

ksmps = 16
channels = sox.file_info.channels(input_file_wav)
sample_rate = sox.file_info.sample_rate(input_file_wav)

#output_tempdir = os.path.dirname(file)
output_tempdir = '/Users/j/Documents/PROJECTs/_temp'

channels = sox.file_info.channels(input_file_wav)

orc_code = f'gSfile init "{input_file_wav}"\n'

with open(input_file_orc, 'r') as f:
	orc_code += f.read()
	sco_python_code = extract_score_data(orc_code)

print(orc_code)

score = []
if sco_python_code is not None:
	try:
		print(sco_python_code)
		for ch in range(channels):
			ch += 1
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
	with open(input_file_orc, 'w') as f:
		f.write(orc_code)
	os.remove(input_file_wav)
	# os.remove(input_file_orc)

	print("File removed successfully.")
except FileNotFoundError:
	print("File not found.")
except Exception as e:
	print("Error removing the file:", str(e))
