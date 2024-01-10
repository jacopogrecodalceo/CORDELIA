import re

input_path = '/Users/j/Desktop/arch_enht5.txt'

intervals_path = '/Users/j/Documents/Obsidian Vault/METHOD/List of intervals.md'
intervals = {}
with open(intervals_path, 'r') as f:
	lines = [line.strip() for line in f.readlines() if line[0].isnumeric()]
	for line in lines:
		match = re.search(r'\d+/\d+', line)
		start_index, end_index = match.span()
		intervals[line[:end_index].strip()] = line[end_index:].strip()

lilyponds = []
base_note_name = ''
base_note_octave = 0
with open(input_path, 'r') as f:
	# a4_"+0.0c"_"00"_"1/1"_"440.0Hz"
	# 00|1/1|A4+0.0c|440.0
	lines = f.readlines()
	for line in lines:
		line = line.strip()
		num, scala_data, note_name_cent, freq = line.split('|')
		match = re.search(r'\d+', note_name_cent)
		start_index, end_index = match.span()

		# Split the string into two parts
		octave = note_name_cent[start_index:start_index+1]
		print(octave)
		note_name = note_name_cent[:start_index].replace('*', '').replace('#', 'is').replace('b', 'es').lower() + '4'
		cents = note_name_cent[end_index:].replace('[***]', '').replace('*', '')
		freq = format(float(freq), '.2f') + 'Hz'

		desc = intervals.get(scala_data, '') 

		lilypond_string = rf'''
{note_name}_"{cents}"^\markup [
	\column [
		\line \left-align \box [
			\fontsize #-3 \rotate #90 [
					"{desc}"
				]		
			]
		\vspace #.15
		\line [{num}]
		\vspace #-.65
		\line [{freq}]
	]
]
		'''
		lilyponds.append(lilypond_string)

#print('\n'.join(lilyponds).replace('[', '{').replace(']', '}'))
