import re

def reaper_get_note_names():
	for i in range(RPR_CountTracks(0)):

		track_id = RPR_GetTrack(0, i)
					
		for j in range(RPR_GetTrackNumMediaItems(track_id)):
			
			item_id = RPR_GetTrackMediaItem(track_id, j)

			take_id = RPR_GetMediaItemTake(item_id, 0)
			source, source_type, size = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(take_id), '', 512)

			if source_type=='MIDI':              

				ret_val, ret_take, MIDI_notes, ret_cc, ret_sysex = RPR_MIDI_CountEvts(take_id, 0, 0, 0)
				for x in range(MIDI_notes):
					note_index = x
					ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_vel = RPR_MIDI_GetNote(take_id, note_index, 0, 0, 0, 0, 0, 0, 0)
					
					ppqdur = endppqposOut-startppqposOut
					note_start = RPR_MIDI_GetProjTimeFromPPQPos(take_id, startppqposOut)
					note_dur = RPR_MIDI_GetProjTimeFromPPQPos(take_id, ppqdur)
					note_vel = float(note_vel)/512


					note_name = str(RPR_GetTrackMIDINoteNameEx(0, track_id, note_pitch, note_chn))
				
					# note name to frequency
					if re.findall(r"\/", note_name):
						ratio = re.findall(r"\d+\/\d+", note_name)[0]
						octave = 2 ** int(re.findall(r"\((.*)\)", note_name)[0])

						note_freq = f"440 * {ratio} * {octave}"
					else:
						note_freq = note_name

					text_retval, take, textsyxevtidx, selectedOutOptional, mutedOutOptional, ppqposOutOptional, typeOutOptional, msgOptional, msgOptional_sz = RPR_MIDI_GetTextSysexEvt(take_id, note_index, 0, 0, 0, 0, 0, 512)
					if text_retval:
						# i don't know why, but i need to remove 2 character from the end of the text string
						note_envelope = msgOptional[:-2:]
					else:
						note_envelope = 'classic'
					
					midi_string = f"eva_midi {note_start}, {note_dur}, {note_vel}, gi{note_envelope}, {note_freq}"

					RPR_ShowConsoleMsg(midi_string + "\n")



reaper_get_note_names()