import json
import math
from pathlib import Path

CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIA'

with open(f'{CORDELIA_DIR}/rpr/midi_name_freq.json') as f:
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
			freq = round(float(base_frequency) * decimal, 5)
			self.freq.append(freq)
			self.midi.append(i)
			

			index_nearest = find_index_of_nearest(MIDI_NAME_FREQ['freq'], freq)

			if index_nearest == base_midi_note:
				nearest_note_name = MIDI_NAME_FREQ['note_name'][index_nearest] + '[***]'
			else:
				nearest_note_name = MIDI_NAME_FREQ['note_name'][index_nearest]
			
			if nearest_note_name.startswith('C4'):
				nearest_note_name += '[***]'

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

				self.edo12diff.append(f'{nearest_note_name}\t{text_cent}c'.expandtabs(numt))

			except Exception as e:
				log(e)
				log(f'freq is {freq} and {self.decimal_values}')

def main():

	retval, scala_path, title, defex = RPR_GetUserFileNameForRead(f'{CORDELIA_DIR}/_core/4-clothes/SCALA/_current/', 'Path', 'scl')
	tuning = Tuning(scala_path)

	if len(tuning.scala_data) != int(tuning.length):
		log(f'WARNING: {tuning.name} length is not the same as the values!\nWritten length is {tuning.length} and calculated {len(tuning.scala_data)}')

	if retval:

		retval, title, num_inputs, captions_csv, retvals_csv, retvals_csv_sz = RPR_GetUserInputs('Base frequency', 1, 'Insert base frequency', 'a4', 128)
		base_frequency_name = retvals_csv.upper()

		base_midi_note = MIDI_NAME_FREQ['note_name'].index(base_frequency_name)
		base_frequency = MIDI_NAME_FREQ['freq'][base_midi_note]

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

			sel_take = RPR_MIDIEditor_GetTake(RPR_MIDIEditor_GetActive())
			sel_track = RPR_GetMediaItemTake_Track(sel_take)

			RPR_Undo_BeginBlock()

			for i in range(len(tuning.freq)):
				string = f'{tuning.edo12diff[i]}\t\t\t\t\t{tuning.freq[i]}\n'
				retval = RPR_SetTrackMIDINoteNameEx(0, sel_track, int(i), -1, string)

			RPR_Undo_EndBlock('Insert tuning', 0)

main()

