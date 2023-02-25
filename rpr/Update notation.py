import re
#RPR_MIDI_InsertTextSysexEvt

MIDI_CORRECTION = 4096

def log(string):
	RPR_ShowConsoleMsg(str(string) + '\n')

class CORDELIA_track():

	is_solo = True
	is_mute = False

	def __init__(self, track_id):
		
		self.id = None
		self.name = None
		self.parent_name = None
		self.num = None

		#get name of the track
		retval, meditem, parname, track_name, var = RPR_GetSetMediaTrackInfo_String(track_id, 'P_NAME', 0, 0)

		#CHECK IF TRACK IS A FOLDER: 0=normal, 1=track is a folder parent
		track_depth = RPR_GetMediaTrackInfo_Value(track_id, 'I_FOLDERDEPTH')
		if track_depth==1:
			CORDELIA_track.is_mute = bool(RPR_GetMediaTrackInfo_Value(track_id, 'B_MUTE'))
			if RPR_AnyTrackSolo(0):
				CORDELIA_track.is_solo = bool(RPR_GetMediaTrackInfo_Value(track_id, 'I_SOLO') > 0)
		
		if CORDELIA_track.is_solo and not CORDELIA_track.is_mute:
			self.id = track_id
			self.name = track_name
			self.num = int(RPR_GetMediaTrackInfo_Value(track_id, 'IP_TRACKNUMBER'))
			retval, meditem, parname, parent_name, var = RPR_GetSetMediaTrackInfo_String(RPR_GetParentTrack(track_id), 'P_NAME', 0, 0)
			if parent_name:
				self.parent_name = re.match(r'@\w+', str(parent_name))[0]

class CORDELIA_item(CORDELIA_track):

	def __init__(self, current_pos, index_on_track, track_id):

		self.id = None
		self.start_pos = None
		self.length = None
		self.source_type = None
		self.index_on_track = index_on_track
		self.take_id = None
		self.after_cursor = False

		self.id  = RPR_GetTrackMediaItem(track_id, self.index_on_track)
		item_pos = RPR_GetMediaItemInfo_Value(self.id, 'D_POSITION')

		if current_pos <= item_pos:

			self.after_cursor = True
			self.length = RPR_GetMediaItemInfo_Value(self.id, 'D_LENGTH')
			self.take_id = RPR_GetMediaItemTake(self.id, 0)
			self.start_pos = item_pos-current_pos

			source, self.source_type, size = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(self.take_id), '', 512)
			if not self.source_type:
				self.source_type = 'SCORE'
				
class CORDELIA_score():

	def __init__(self, item_id):
		self.text = None
		retval, meditem, parname, self.text, var = RPR_GetSetMediaItemInfo_String(item_id, 'P_NOTES', 0, 0)

class CORDELIA_midi():

	def __init__(self, index, track_id, take_id):

		self.name = None
		self.start = None
		self.dur = None
		self.dyn = None
		self.env = 'classic'

		note_index = index
		ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_velocity = RPR_MIDI_GetNote(take_id, note_index, 0, 0, 0, 0, 0, 0, 0)

		self.startppqpos = startppqposOut
		ppqdur = endppqposOut-startppqposOut
		name = str(RPR_GetTrackMIDINoteNameEx(0, track_id, note_pitch, note_chn))

		self.name = re.search(r'c.\s+(.*)', name)[1]
		self.start = RPR_MIDI_GetProjTimeFromPPQPos(take_id, startppqposOut)
		self.dur = RPR_MIDI_GetProjTimeFromPPQPos(take_id, ppqdur)
		self.dyn = float(note_velocity)/MIDI_CORRECTION		
		text_retval, take, textsyxevtidx, selectedOutOptional, mutedOutOptional, ppqposOutOptional, typeOutOptional, msgOptional, msgOptional_sz = RPR_MIDI_GetTextSysexEvt(take_id, note_index, 0, 0, 0, 0, 0, 512)
		if text_retval:
			# i don't know why, but i need to remove 2 character from the end of the text string
			self.env = msgOptional[:-2:]

def main():
	current_pos = RPR_GetCursorPosition()
	for i in range(RPR_CountTracks(0)):
		track = CORDELIA_track(RPR_GetTrack(0, i))
		if track.id:
			for j in range(RPR_GetTrackNumMediaItems(track.id)):
				item = CORDELIA_item(current_pos, j, track.id)
				if item.after_cursor:
					if item.source_type == 'MIDI':
						ret_val, ret_take, MIDI_notes, ret_cc, ret_sysex = RPR_MIDI_CountEvts(item.take_id, 0, 0, 0)
						for index in range(MIDI_notes):
							midi = CORDELIA_midi(index, track.id, item.take_id)
							#retval = RPR_MIDI_InsertTextSysexEvt(item.take_id, False, False, midi.startppqpos, 15, 'ehiehie', 1024)
							retval = RPR_MIDI_SetTextSysexEvt(item.take_id, j, False, False, midi.startppqpos, 15, 'sadsd', 1024, 0)

main()
