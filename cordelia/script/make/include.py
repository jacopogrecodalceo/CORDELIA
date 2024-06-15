import os

def make(orc, directory):
	includes = []
	for root, _, files in os.walk(directory):
		for f in files:
			if f.endswith('.orc') and f.split('.')[0] not in ['option', 'include', 'setting']:
				includes.append(f'"{os.path.join(root, f)}"')
	includes.sort()
	includes = ['#include ' + item for item in includes]

	with open(orc, 'w') as include_file:
		include_file.write('\n'.join(includes))

