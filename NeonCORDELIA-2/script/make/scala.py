import os
import re
import json

def find_duplicate_files(directory):
	file_dict = {}

	for root, _, files in os.walk(directory):
		for filename in files:
			basename, extension = os.path.splitext(filename)
			if filename != '.DS_Store' and extension == '.scl':
				file_path = os.path.join(root, basename)
				if basename in file_dict:
					file_dict[basename].append(file_path)
				else:
					file_dict[basename] = [file_path]

	duplicate_files = {filename: paths for filename, paths in file_dict.items() if len(paths) > 1}

	if not duplicate_files:
		print("No duplicate files found.")
		return True
	else:
		print("Duplicate files found:")
		for filename, paths in duplicate_files.items():
			print(f"File '{filename}' is duplicated at:")
			for path in paths:
				print(f"  {path}")
		return False

def find_nonstandard_names(directory):
	for root, _, files in os.walk(directory):
		for filename in files:
			_, extension = os.path.splitext(filename)
			if filename != '.DS_Store' and extension == '.scl':
				file_path = os.path.join(root, filename)
				if re.search(r'\s', filename):
					print(file_path)
					return False
					#rename_file(file_path, os.path.join(root, filename.replace(' ', '_')))
	return True

def round_large_integer(number):
	number = int(number)
	max_64bit_int = 2 ** 63 - 1  # Maximum 64-bit signed integer
	if number > max_64bit_int:
		rounded_number = round(number, -15)  # Round to 15 significant digits
		return rounded_number
	else:
		return number

def process_scala(directory, json_file):
	scala = {}

	for root, _, files in os.walk(directory):
		for filename in files:
			basename, extension = os.path.splitext(filename)
			if extension == '.scl':
				file_path = os.path.join(root, filename)
				with open(file_path, 'r', encoding='latin1') as f:
					lines = [line.strip() for line in f.readlines() if not line.strip().startswith('!')]

				description = lines[0] if lines[0] != '' else None
				degrees = lines[1].split()[0]

				tuning_value = []
				for value in lines[2:]:
					value = value.split('!')[0]

					if '(' in value:
						res = value
					elif '/' in value:
						numbers = []

						# Split the value into components based on '/'
						components = value.split('/')

						# Iterate through each component and handle rounding if necessary
						for component in components:
							component = round_large_integer(component)
							numbers.append(str(component))

						# Join the modified components back together using '/'
						res = '/'.join(numbers)
						
					else:
						res = str(2 ** (float(value.split()[0]) / 1200))

					tuning_value.append(str(res))

				interval = tuning_value[-1]

				if degrees != str(len(tuning_value)):
					print('WARNING --- degrees are different from the tuning values')

				base_val = '1'
				basefreq = 'A4'
				basekey = '69'

				ftgen_string = f'gi{basename} ftgen 0, 0, 0, -2, {degrees}, {interval}, {basefreq}, {basekey}, {base_val}, {", ".join(tuning_value)}'
				scala[basename] = {
					'path': file_path,
					'description': description,
					'default_ftgen': ftgen_string,
					'degrees': degrees,
					'interval': interval,
					'tuning_values': ", ".join(tuning_value)
				}

	with open(json_file, 'w') as f:
		json.dump(scala, f, indent=4)
	return True

def make(scala_dir, scala_json):
    ret = find_duplicate_files(scala_dir)
    if ret:
        ret = find_nonstandard_names(scala_dir)
    if ret:
        ret = process_scala(scala_dir, scala_json)
