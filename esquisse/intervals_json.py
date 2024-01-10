import json
import re

def get_intervals():
	intervals_path = '/Users/j/Documents/Obsidian Vault/METHOD/List of intervals.md'
	intervals = {}
	with open(intervals_path, 'r') as f:
		lines = [line.strip() for line in f.readlines() if line[0].isnumeric()]
		for line in lines:
			match = re.search(r'\d+/\d+', line)
			start_index, end_index = match.span()
			intervals[line[:end_index].strip()] = line[end_index:].strip()
	return intervals

intervals = get_intervals()

file_path = '/Users/j/Documents/PROJECTs/CORDELIA/_SCALA/notation/_intervals.json'

# Write the JSON string to the file
with open(file_path, 'w') as json_file:
    json.dump(intervals, json_file, indent=4)
