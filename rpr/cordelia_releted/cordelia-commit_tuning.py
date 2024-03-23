import json, math, re, os, json, subprocess

from pathlib import Path

CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIA'
homebrew_directory = '/opt/homebrew/bin'

# Modify the PATH environment variable
os.environ['PATH'] = f"{homebrew_directory}:{os.environ['PATH']}"

with open(f'{CORDELIA_DIR}/cordelia/config/SCALA.json') as f:
	SCALA_JSON = json.load(f)

with open(f'{CORDELIA_DIR}/rpr/cordelia_releted/midi_name_freq.json') as f:
	MIDI_NAME_FREQ = json.load(f)

def log(string):
	RPR_ShowConsoleMsg(str(string) + '\n')

def find_index_of_nearest(array, value):

	resval = array[min(range(len(array)), key=lambda i: abs(array[i]-value))]
	index = array.index(resval)

	return index


class Tuning():

	def __init__(self, path):
		self.freq = []
		self.midi = []
		self.edo12diff = []

		self.scala = Path(path)
		self.name = self.scala.stem

		lines = []
		with open(path) as f:
			for line in f:
				if not line.startswith('!'):
					lines.append(line.strip())
		
		self.description = lines[0]
		self.length = lines[1]
		self.scala_data = lines[2:]
		self.gen_decimal_values()

	def gen_decimal_values(self):
		decimal_values = [1]
		for value in self.scala_data:
			if '.' in value:
				decimal_values.append(2 ** (float(value)/1200))
			elif '/' in value:
				decimal_values.append(eval(value))
			else:
				decimal_values.append(value)
		
		self.decimal_values = decimal_values

	def gen_frequency_values(self, base_frequency, base_midi_note):
		length = int(self.length)
		for i in range(128):
			offset = i - base_midi_note
			quotient = math.floor(offset / length)
			remainder = offset % length
			if remainder < 0:
				remainder += length
			period = self.decimal_values[length]
			# "decimal" here means a frequency ratio, but stored in decimal format
			decimal = self.decimal_values[remainder] * math.pow(period, quotient)
			#log(float(base_frequency) * decimal)

			# store the data in the tuning_table object
			# freq = round(float(base_frequency) * decimal, 5)
			freq = float(base_frequency) * decimal
			self.freq.append(freq)
			self.midi.append(i)
			
			index_nearest = find_index_of_nearest(MIDI_NAME_FREQ['freq'], freq)

			step_size = 12
			limit = 127
			base_midi_octaves_notes = [num for num in range(base_midi_note + step_size, limit, step_size) if num < limit] + [num for num in range(base_midi_note - step_size, -1, -step_size) if num >= 0]

			if index_nearest in base_midi_octaves_notes:
				nearest_note_name = MIDI_NAME_FREQ['note_name'][index_nearest] + '[***]'
			else:
				nearest_note_name = MIDI_NAME_FREQ['note_name'][index_nearest]
			
			if nearest_note_name.startswith('C4'):
				nearest_note_name = '*C4*'

			freq_edo12 = MIDI_NAME_FREQ['freq'][index_nearest]
			ratio_freq = freq / freq_edo12

			try:
				cent_diff = float(1200) * math.log2(float(ratio_freq))
				rounded_cent = round(cent_diff, 2)

				if not rounded_cent < 0:
					text_cent = f'+{rounded_cent}'
				else:
					text_cent = rounded_cent


				space = 9
				if len(nearest_note_name) == 2:
					numt = space
				elif len(nearest_note_name) == 3:
					numt = space-1
				else:
					numt = space-(space-1)

				self.edo12diff.append(f'{nearest_note_name}{text_cent}c'.expandtabs(numt))

			except Exception as e:
				log(e)
				log(f'freq is {freq} and {self.decimal_values}')

scala_regex = re.compile(r'scala\.(\w+)')

def get_if_base_freq(track_name):
	if '@' in track_name:
		name = track_name.split('@')[0]
		base_freq = track_name.split('@')[1]
		base_freq = base_freq.split(',')[0]
		return name, base_freq
	else:
		return track_name, 'a4'

def get_tuning(track_name):
	if 'scala' in track_name:
		name, base_freq = get_if_base_freq(track_name)

		match = scala_regex.search(name)
		if match:
			scala_name = match.group(1)
			try:
				tuning = Tuning(SCALA_JSON[scala_name]['path'])
				return tuning, base_freq
			except:
				log(f'WARNING: Invalid scala name for {scala_name}')

	edo12_path = '/Users/j/Documents/PROJECTs/CORDELIA/_SCALA/_current/edo/_edo12.scl'
	tuning = Tuning(edo12_path)
	base_freq = 'a4'
	return tuning, base_freq

def main():

	for i in range(RPR_CountTracks(0)):
		track_id = RPR_GetTrack(0, i)
		retval, meditem, parname, track_name, var = RPR_GetSetMediaTrackInfo_String(track_id, 'P_NAME', 0, 0)

		tuning, base_freq = get_tuning(track_name)

		if len(tuning.scala_data) != int(tuning.length):
			log(f'WARNING: {tuning.name} length is not the same as the values!\nWritten length is {tuning.length} and calculated {len(tuning.scala_data)}')

		#retval, title, num_inputs, captions_csv, retvals_csv, retvals_csv_sz = RPR_GetUserInputs('Base frequency', 1, 'Insert base frequency', 'a4', 128)
		
		if base_freq[0].isalpha():
			base_frequency_name = base_freq.capitalize()

			base_midi_note = MIDI_NAME_FREQ['note_name'].index(base_frequency_name)
			base_frequency = MIDI_NAME_FREQ['freq'][base_midi_note]
		else:
			base_frequency = float(eval(base_freq))
			base_midi_note = min(range(len(MIDI_NAME_FREQ['freq'])), key=lambda i: abs(MIDI_NAME_FREQ['freq'][i] - base_frequency))

		if retval:
			
			tuning.gen_frequency_values(base_frequency, base_midi_note)

			#log(base_frequency)
			#log(base_midi_note)

			#log(tuning.freq)
			#log(tuning.edo12diff)

			# with open('/Users/j/Desktop/1.txt', 'w') as f:
			# 	first_line = '# MIDI note / CC name map\n'
			# 	f.write(first_line)
			# 	for each in reversed(range(len(tuning.freq))):
			# 		f.write(f'{str(each)} {tuning.edo12diff[each]},\t\t\t\t\t{tuning.freq[each]}\n')

			RPR_Undo_BeginBlock()

			for i in range(len(tuning.freq)):
				#index = abs(i-base_midi_note)%len(tuning.scala_data)
				index = (i - base_midi_note) % len(tuning.scala_data)
				formatted_index = str(index).zfill(2)

				scala_data = '1/1' if index == 0 else tuning.scala_data[index-1][:5]

				string = f'{formatted_index}|{scala_data}|{tuning.edo12diff[i]}\t\t\t\t\t{tuning.freq[i]}'
				retval = RPR_SetTrackMIDINoteNameEx(0, track_id, int(i), -1, string)
			
			RPR_Undo_EndBlock('Insert tuning', 0)

			def increment_first_numeric(input_string):
				# Find the first numeric part in the string
				match = re.search(r'\d+', input_string)

				if match:
					# Increment the first numeric part by 1
					incremented_numeric = str(int(match.group()) + 1)

					# Replace the first numeric part in the original string
					input_string = re.sub(r'\d+', incremented_numeric, input_string, 1)

				return input_string

			base_frequency_name_octave = increment_first_numeric(base_frequency_name)
			
			notation_dir = os.path.join(CORDELIA_DIR, '_SCALA/notation/')
			intervals_json = os.path.join(notation_dir, '_intervals.json')
			with open(intervals_json, 'r') as json_file:
				intervals = json.load(json_file)

			lilypond_output_path = os.path.join(notation_dir, f'{tuning.name}.ly')
			pdf_output_path = os.path.join(notation_dir, f'{tuning.name}.pdf')
			lilypond_init_path = os.path.join(notation_dir, '_init.ly')
			lilyponds = []
			with open(lilypond_init_path, 'r') as f:
				for i in range(base_midi_note, len(tuning.freq)):
					if base_frequency_name_octave in tuning.edo12diff[i] and '0.0' in tuning.edo12diff[i]:
						break
					index = (i - base_midi_note) % len(tuning.scala_data)
					formatted_index = str(index).zfill(2)
					scala_data = '1/1' if index == 0 else tuning.scala_data[index-1][:5]
					note_name_cent = tuning.edo12diff[i]

					match = re.search(r'\d+', note_name_cent)
					start_index, end_index = match.span()

					note_name = note_name_cent[:start_index].replace('*', '').replace('#', 'is').replace('b', 'es').lower()
					cents = note_name_cent[end_index:].replace('[***]', '').replace('*', '')
					freq = format(float(tuning.freq[i]), '.2f') + 'Hz'
					desc = intervals.get(scala_data, '') 

					note_name += '4'

					lilypond_string = rf'''
						{note_name}_"{cents}"^\markup [
							\column [
								\line \left-align \box [
									\fontsize #-3 \rotate #90 [
											"{desc}"
										]		
									]
								\vspace #.15
								\line ["{formatted_index}"]
								\vspace #-.65
								\line ["{scala_data}"]
								\vspace #-.65
								\line ["{freq}"]
							]
						]
					'''
					lilyponds.append(lilypond_string)


			main_replace = '\n'.join(lilyponds).replace('[', '{').replace(']', '}')
			with open(lilypond_init_path, 'r') as f:
				main_lilypond = f.read().replace('---MAIN---', main_replace)
				main_lilypond = main_lilypond.replace('---LENGTH---', str(tuning.length))
				main_lilypond = main_lilypond.replace('---NAME---', tuning.name.replace('_', ' ').strip().upper())
				with open(lilypond_output_path, 'w') as f:
					f.write(main_lilypond)
		if not os.path.exists(pdf_output_path):
			command = ['lilypond', '-djob-count=10', '-o',  f'{notation_dir}', f'{lilypond_output_path}']
			result = subprocess.run(command, capture_output=True, text=True)

			# Check the return code
			if result.returncode != 0:
				log(result.stderr)

main()

