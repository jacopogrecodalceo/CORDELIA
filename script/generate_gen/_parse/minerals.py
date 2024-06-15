import csv, re

csv_path = '/Users/j/Documents/PROJECTs/CORDELIA/script/generate_gen/_data/minerals.csv'

# Open the CSV file and read its contents
with open(csv_path, 'r') as csvfile:
	csvreader = csv.reader(csvfile)

	# Create a list to store the rows
	rows = []

	# Loop through each row in the CSV file and add it to the list
	for row in csvreader:
		rows.append(row)

replace_with_line = ['-']
replace_with_nothing = ['(', ')', "'", 'mineral', ' ']

# Print the list of rows
for r in rows:

	name = r[0].strip()
	for each in replace_with_line:
		if each in name:
			name = name.replace(each, '_')
	
	for each in replace_with_nothing:
		if each in name:
			name = name.replace(each, '')

	mohs = r[1].strip()

	# remove spaces
	if '-' in mohs:
		mohs = re.sub(r'\W*(-)\W*', '-', mohs)
		import re

		number_pat = r'^-?\d+(\.\d+)?$'

		if '+' in mohs:
			matches = re.findall(number_pat, mohs)
			print(mohs)
			print(matches)

	#if re.findall(r'\W', mohs):

	gravity = r[2].strip()




