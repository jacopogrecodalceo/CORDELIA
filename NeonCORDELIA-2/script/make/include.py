import os

def make(orc, directory):
	with open(orc, 'w') as include_file:
		for root, _, files in os.walk(directory):
			for f in files:
				if f.endswith('.orc'):
					include_file.write(f'#include "{os.path.join(root, f)}"\n')
					break

