import os
import json

from datetime import datetime 

cordelia_init_code = []
cordelia_compile = []

cordelia_given_else = []
cordelia_given_instr = ['mouth']

cordelia_instr_start_num = 215

cordelia_date = datetime.today().strftime('%y%m%d-%H%M')

memories = True

def make_json(dictonary, directory):
	for file_name in os.listdir(directory):
		if file_name.endswith('.json'):
			file_path = os.path.join(directory, file_name)
			with open(file_path, 'r') as f:
				key = file_path.split('/')[-1].split('.')[0]
				dictonary[key] = json.load(f)

cordelia_json = {}
json_dir = './config/'
make_json(cordelia_json, json_dir)

cordelia_alias = {}

alias_path = './config/alias/alias.json'
with open(alias_path, 'r') as f:
	cordelia_alias['alias'] = json.load(f)

complex_path = './config/alias/complex.json'
with open(complex_path, 'r') as f:
	cordelia_alias['complex'] = json.load(f)

