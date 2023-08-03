import sox
import os
import subprocess

file = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/ciel.wav'
basename = os.path.splitext(os.path.basename(file))[0]

#output_dir = os.path.dirname(file)
output_dir = '/Users/j/Desktop'

mono_files = []

def main(file):
	channels = sox.file_info.channels(file)
	for i in range(1, channels+1):
		tfm = sox.Transformer()
		output_file = os.path.join(output_dir, basename + f'-{i}ch.wav')
		print(f'Writing {i} channel of {basename} to {output_file}')
		tfm.remix(remix_dictionary={1: [i]}, num_output_channels=1)
		tfm.build(input_filepath=file, output_filepath=output_file)
		mono_files.append(output_file)

	for f in mono_files:
		input_file = f
		output_file = os.path.join(output_dir, f'{os.path.splitext(os.path.basename(input_file))[0]}.ats')
		csound_command = ['csound', '-U', 'atsa', input_file, output_file]
		process = subprocess.Popen(csound_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		stdout, stderr = process.communicate()
		if process.returncode != 0:
			print(f"An error occurred: {stderr.decode('utf-8')}")
		else:
			print(f'Csound processing {input_file} completed successfully.')

if __name__ == '__main__':
	main(file)