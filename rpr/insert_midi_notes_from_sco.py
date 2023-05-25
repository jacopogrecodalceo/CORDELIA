import re

def log(string):
	RPR_ShowConsoleMsg(str(string) + '\n')

def get_tuning_list(take):

	track = RPR_GetMediaItemTake_Track(take)

	names = []
	cent_diffs = []
	freqs = []

	for i in range(0, 127):
		strings = str(RPR_GetTrackMIDINoteNameEx(0, track, i, 0)).split()
		#freq = re.search(r'c.\s+(.*)', freq)[1]
		#freqs.append(float(freq))
		names.append(strings[0].strip())
		cent_diffs.append(strings[1].strip())
		freqs.append(float(strings[2].strip()))
	
	return names, cent_diffs, freqs

def find_index_of_nearest(array, value):

	nearest_value = array[min(range(len(array)), key=lambda i: abs(array[i]-value))]
	index = array.index(nearest_value)

	return nearest_value, index

def insert_midi_note(take, time: float, duration: float, pitch: int):
	note = {}

	note["selected"] = True  # Set the note as selected
	note["mute"] = False  # Set the note as unmuted
	note["ppq_start"] = RPR_MIDI_GetPPQPosFromProjTime(take, time)  # Set the note start position in PPQ
	note["ppq_end"] = RPR_MIDI_GetPPQPosFromProjTime(take, time + duration)  # Set the note end position in PPQ
	note["pitch"] = pitch  # Set the note pitch (MIDI note number)
	note["vel"] = 95  # Set the note velocity (0-127)

	# Insert the note into the take
	RPR_MIDI_InsertNote(take, True, False, note["ppq_start"], note["ppq_end"], 0, note["pitch"], note["vel"], True)



def main(file_path):
	# Get the active MIDI editor
	midieditor = RPR_MIDIEditor_GetActive()

	# Check if a MIDI editor is open
	if midieditor != 0:
		# Get the current take in the MIDI editor
		take = RPR_MIDIEditor_GetTake(midieditor)

		# Check if the take is valid
		if take != 0:
		
			names, cent_diffs, freqs = get_tuning_list(take)
			# Create a new MIDI note

			with open(file_path, 'r') as file:
				
				first_time = None
				round_val = 2

				for line in file:
					for line in file:
						param = line.strip()
						name, time, dur, dyn, env, freq = param.split(', ')

						if first_time is None:
							first_time = time

						#time = float(time) - float(first_time)
						nearest_value, midi_note_num = find_index_of_nearest(freqs, float(freq))

						main_freq = round(float(freq), round_val)
						nearest_freq = round(nearest_value, round_val)
						string = [
							'MAIN:\t' + str(main_freq) + ' >> ' + str(nearest_freq) + f' [{names[midi_note_num]}{cent_diffs[midi_note_num]}, {str(midi_note_num)}]',
							'BEFORE:\t' + str(round(freqs[midi_note_num-1], round_val)) + f' [{names[midi_note_num-1]}]',
							'AFTER:\t\t' + str(round(freqs[midi_note_num+1], round_val)) + f' [{names[midi_note_num+1]}]',
							'------------------------------------------------']
						
						if main_freq != nearest_freq:
							log('\n'.join(string))

						insert_midi_note(take, float(time), float(dur), int(midi_note_num))

	# Update the MIDI editor display
	RPR_MIDIEditor_OnCommand(midieditor, RPR_NamedCommandLookup("_BR_ME_REFRESH"))

retval, file_path, title, defex = RPR_GetUserFileNameForRead('/Users/j/Documents/PROJECTs/CORDELIA/script', 'Path', 'txt')

if retval:
	main(file_path)
