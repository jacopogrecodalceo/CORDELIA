import re, os

def log(string):
	RPR_ShowConsoleMsg(str(string) + '\n')


def main(file_path):
	# Get the active MIDI editor
	midieditor = RPR_MIDIEditor_GetActive()

	# Check if a MIDI editor is open
	if midieditor != 0:
		# Get the current take in the MIDI editor
		take = RPR_MIDIEditor_GetTake(midieditor)

		# Check if the take is valid
		if take != 0:
		
			ret_val, ret_take, notecntOut, ret_cc, ret_sysex = RPR_MIDI_CountEvts(take, 0, 0, 0)
			for note_index in range(notecntOut):
				ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_velocity = RPR_MIDI_GetNote(take, note_index, 0, 0, 0, 0, 0, 0, 0)
				
				# Sinstr, gkabstime, kdur, kamp, kenv, $kcps
				name = 'dummy'
				start_pos = RPR_MIDI_GetProjTimeFromPPQPos(take, startppqposOut)
				end_pos = RPR_MIDI_GetProjTimeFromPPQPos(take, endppqposOut)
				dur = end_pos - start_pos
				amp = .5
				env = 1
				freq = str(RPR_GetTrackMIDINoteNameEx(0, RPR_GetMediaItemTake_Track(take), note_pitch, note_chn))
				freq = re.search(r'c.\s+(.*)', freq)[1]

				string_mix = [name, start_pos, dur, amp, env, freq]
				string = [str(element) for element in string_mix]

				with open(file_path, 'a') as file:
					file.write(', '.join(string))
					file.write('\n')

	# Update the MIDI editor display
	RPR_MIDIEditor_OnCommand(midieditor, RPR_NamedCommandLookup("_BR_ME_REFRESH"))

project_num, project_name_ext, buf_size = RPR_GetProjectName(0, "", 512)
project_name = project_name_ext.rsplit(".", 1)[0]

file_path = '/Users/j/Desktop' + f'/{project_name}-score.txt'
if os.path.exists(file_path):
	os.remove(file_path)
main(file_path)
