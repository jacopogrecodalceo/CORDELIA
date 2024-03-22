import json

def make(json_routing, json_output):

	with open(json_routing, 'r') as f:
		routing = json.load(f)

	with open(json_output, 'r') as f:
		output = json.load(f)

	keys = [item for item in routing.keys()]

	# Iterate through the list and update the pattern for "OPCO"
	for item in output:
		if item['type'] == 'ROUTING':
			item['pattern'] = rf'\.(?:{"|".join(keys)})(?:\b|$)'

	# Write the updated JSON data back to the file
	with open(json_output, 'w') as f:
		json.dump(output, f, indent=4)
