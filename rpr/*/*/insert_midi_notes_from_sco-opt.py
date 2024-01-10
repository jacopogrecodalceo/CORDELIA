import numpy as np

def log(string):
	RPR_ShowConsoleMsg(str(string) + '\n')

def get_tuning_list(take):
	track = RPR_GetMediaItemTake_Track(take)

	note_data = [str(RPR_GetTrackMIDINoteNameEx(0, track, i, 0)).split() for i in range(0, 127)]
	
	names = [item[0] for item in note_data]
	cent_diffs = [item[1] for item in note_data]
	freqs = [item[2] for item in note_data]

	return names, cent_diffs, freqs

def find_index_of_nearest(array, value):
	array = np.array(array)
	index = np.abs(array - value).argmin()
	nearest_value = array[index]
	return nearest_value, index

def insert_midi_note(take, time: float, duration: float, pitch: int, velocity: int):

	note = {}

	note["selected"] = True  # Set the note as selected
	note["mute"] = False  # Set the note as unmuted
	note["ppq_start"] = RPR_MIDI_GetPPQPosFromProjTime(take, time)  # Set the note start position in PPQ
	note["ppq_end"] = RPR_MIDI_GetPPQPosFromProjTime(take, time + duration)  # Set the note end position in PPQ
	note["pitch"] = pitch  # Set the note pitch (MIDI note number)
	note["vel"] = velocity  # Set the note velocity (0-127)

	# Insert the note into the take
	RPR_MIDI_InsertNote(take, True, False, note["ppq_start"], note["ppq_end"], 0, note["pitch"], note["vel"], True)



def main(file_path):
	# Get the active MIDI editor
	midieditor = RPR_MIDIEditor_GetActive()

	# Check if a MIDI editor is open and the take is valid
	if midieditor != 0 and (take := RPR_MIDIEditor_GetTake(midieditor)) != 0:
		names, cent_diffs, freqs = get_tuning_list(take)
		first_time = None

		with open(file_path, 'r') as file:
			lines = file.read().splitlines()

			for line in lines:
				param = line.strip()
				name, time, dur, dyn, env, freq = param.split(', ')

				if first_time is None:
					first_time = time

				nearest_value, midi_note_num = find_index_of_nearest(freqs, float(freq))

				# round_val = 2
				# main_freq = round(float(freq), round_val)
				# nearest_freq = round(nearest_value, round_val)

				# string = [
				#     'MAIN:\t' + str(main_freq) + ' >> ' + str(nearest_freq) + f' [{names[midi_note_num]}{cent_diffs[midi_note_num]}, {str(midi_note_num)}]',
				#     'BEFORE:\t' + str(round(freqs[midi_note_num-1], round_val)) + f' [{names[midi_note_num-1]}]',
				#     'AFTER:\t\t' + str(round(freqs[midi_note_num+1], round_val)) + f' [{names[midi_note_num+1]}]',
				#     '------------------------------------------------'
				# ]

				# if main_freq != nearest_freq:
				#     log('\n'.join(string))

				insert_midi_note(take, float(time), float(dur), int(midi_note_num), int(float(dyn)*127))


	# Update the MIDI editor display
	RPR_MIDIEditor_OnCommand(midieditor, RPR_NamedCommandLookup("_BR_ME_REFRESH"))

retval, file_path, title, defex = RPR_GetUserFileNameForRead('/Users/j/Documents/PROJECTs/CORDELIA/script', 'Path', 'txt')

if retval:
	main(file_path)
