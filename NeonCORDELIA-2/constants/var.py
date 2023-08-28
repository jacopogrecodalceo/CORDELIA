import os
import json

cordelia_init_code = []
cordelia_compile = []

cordelia_given = []

cordelia_instr_start_num = 215

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
json_dir = os.path.join(json_dir, 'alias/')
make_json(cordelia_alias, json_dir)

