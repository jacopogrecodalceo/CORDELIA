import json
import os

def make(directory, json_file):
	gen = {}
	for root, _, files in os.walk(directory):
		for f in files:
			if f.endswith('.orc'):
				name = os.path.splitext(f)[0]
				with open(os.path.join(root, f), 'r') as f:
					gen[name] = f.read()
				
	with open(json_file, 'w') as f:
		json.dump(gen, f, indent=4)

