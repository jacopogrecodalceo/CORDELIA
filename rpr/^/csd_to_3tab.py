import re
import pprint
file_path = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/ATS/cheby-seno-full.orc'

csmain = []
with open(file_path, 'r') as f:
	lines = f.readlines()
	for line in lines:

		cstab = [''] * 3

		if re.search(r'^\w+', line):

			# check if after each space there's a comma
			words = line.split()
			first = []
			for i, w in enumerate(words):
				first.append(w)
				if w[-1] != ',':
					break
			cstab[0] = ''.join(first)
			
			# check the opcode
			opcode_index = line.find(first[-1])+len(first[-1])
			opcode_line = line[opcode_index:].split()
			if opcode_line:
				cstab[1] = opcode_line[0]
		
				# last
				last_index = line.find(opcode_line[0])+len(opcode_line[0])
				cstab[2] = line[last_index:].strip()
			csmain.append(cstab)
		else:
			if re.search(r'\w+', line):
				# find the first word in the line
				words = line.split()
				cstab[1] = words[0]
		
				# last
				last_index = line.find(words[0])+len(words[0])
				cstab[2] = line[last_index:].strip()
				csmain.append(cstab)
			else:

				csmain.append(cstab)

pprint.pprint(csmain)
