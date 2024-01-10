import mido, time
from mido import MidiFile, MidiTrack, Message

midi_output_file = '/Users/j/Desktop/test2.mid'

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

def insert_midi_note(take, time: float, duration: float, pitch: int, velocity: int):
	note = {}

	note["ppq_start"] = RPR_MIDI_GetPPQPosFromProjTime(take, time)  # Set the note start position in PPQ
	note["ppq_end"] = RPR_MIDI_GetPPQPosFromProjTime(take, time + duration)  # Set the note end position in PPQ

	# Insert the note into the take
	RPR_MIDI_InsertNote(take, True, False, note["ppq_start"], note["ppq_end"], 0, pitch, velocity, True)


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

						insert_midi_note(take, float(time), float(dur), int(midi_note_num), int(float(dyn)*127))

	# Update the MIDI editor display
	RPR_MIDIEditor_OnCommand(midieditor, RPR_NamedCommandLookup("_BR_ME_REFRESH"))

def main_to_midi(file_path):
	# Get the active MIDI editor
	midieditor = RPR_MIDIEditor_GetActive()

	# Check if a MIDI editor is open
	if midieditor != 0:
		# Get the current take in the MIDI editor
		take = RPR_MIDIEditor_GetTake(midieditor)

		# Check if the take is valid
		if take != 0:
			midi_file = MidiFile()
			MidiFile.ticks_per_beat = 480
			tempo = mido.bpm2tempo(95)
			track = MidiTrack()
			midi_file.tracks.append(track)
			
			names, cent_diffs, freqs = get_tuning_list(take)
			# Create a new MIDI note

			with open(file_path, 'r') as file:
				
				first_time = None
				prev_time = 0
				round_val = 2

				for line in file:
					for line in file:
						param = line.strip()
						name, time, dur, dyn, env, freq = param.split(', ')

						if first_time is None:
							first_time = time

						#time = float(time) - float(first_time)
						nearest_value, pitch = find_index_of_nearest(freqs, float(freq))
						velocity = int(float(dyn)*127)

						delta_time = float(time) - prev_time

						tick_time = int(mido.second2tick(delta_time, MidiFile.ticks_per_beat, tempo))
						tick_duration = int(mido.second2tick(float(dur) - float(time), MidiFile.ticks_per_beat, tempo))

						# Add note-on message
						track.append(Message('note_on', note=pitch, velocity=velocity, time=tick_time))

						# Add note-off message
						#track.append(Message('note_off', note=pitch, velocity=0, time=tick_duration))
				
						prev_time = float(time)

						#insert_midi_note(take, float(time), float(dur), int(pitch), velocity)

			midi_file.save(midi_output_file)

	# Update the MIDI editor display
	RPR_MIDIEditor_OnCommand(midieditor, RPR_NamedCommandLookup("_BR_ME_REFRESH"))


retval, file_path, title, defex = RPR_GetUserFileNameForRead('/Users/j/Documents/PROJECTs/CORDELIA/script', 'Path', 'txt')

if retval:
	start_time = time.time()
	main_to_midi(file_path)
	elapsed_time = time.time() - start_time
	log(f"Elapsed time: {elapsed_time} seconds")
