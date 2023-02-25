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
				self.parent_name = re.match(r'^\w+', str(parent_name))[0]

class CORDELIA_item(CORDELIA_track):

	def __init__(self, play_pos, index_on_track, track_id):

		self.id = None
		self.start_pos = None
		self.length = None
		self.source_type = None
		self.index_on_track = index_on_track
		self.take_id = None
		self.exists = False
	
		self.id  = RPR_GetTrackMediaItem(track_id, self.index_on_track)
		item_pos = RPR_GetMediaItemInfo_Value(self.id, 'D_POSITION')
		self.length = RPR_GetMediaItemInfo_Value(self.id, 'D_LENGTH')

		if play_pos == item_pos:

			self.exists = True

			self.take_id = RPR_GetMediaItemTake(self.id, 0)
			self.start_pos = item_pos
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

		note_index = index
		ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_velocity = RPR_MIDI_GetNote(take_id, note_index, 0, 0, 0, 0, 0, 0, 0)
		
		ppqdur = endppqposOut-startppqposOut
		self.name = str(RPR_GetTrackMIDINoteNameEx(0, track_id, note_pitch, note_chn))
		self.start = RPR_MIDI_GetProjTimeFromPPQPos(take_id, startppqposOut)
		self.dur = RPR_MIDI_GetProjTimeFromPPQPos(take_id, ppqdur)
		self.dyn = float(note_velocity)/2048
	
		text_retval, take, textsyxevtidx, selectedOutOptional, mutedOutOptional, ppqposOutOptional, typeOutOptional, msgOptional, msgOptional_sz = RPR_MIDI_GetTextSysexEvt(take_id, note_index, 0, 0, 0, 0, 0, 512)


def on_play():
	current_pos = RPR_GetCursorPosition()
	play_pos = RPR_GetPlayPosition2()
	if current_pos > 0:
		for i in range(RPR_CountTracks(0)):
			track = CORDELIA_track(RPR_GetTrack(0, i))
			if track.id:
				for j in range(RPR_GetTrackNumMediaItems(track.id)):
					item = CORDELIA_item(play_pos, j, track.id)
					if item.exists:
						log('HERE')

def check_play():
	
	if RPR_GetPlayState()==1:
		on_play()

	RPR_defer('check_play()')


check_play()	




