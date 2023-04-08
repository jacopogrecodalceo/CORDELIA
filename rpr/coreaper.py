import re
import socket

MIDI_CORRECTION = 1024

CSOUND_STRINGS = []

NAMED_INSTR = []

def append_to_csound(string):
	CSOUND_STRINGS.append(string)

def split_message(message, max_size):
    message_len = len(message.encode())
    if message_len > max_size:
        message_parts = []
        message_lines = message.split('\n')
        current_message = ''
        for line in message_lines:
            line_len = len(line.encode())
            if len(current_message.encode()) + line_len > max_size:
                message_parts.append(current_message.strip())
                current_message = line + '\n'
            else:
                current_message += line + '\n'
        if current_message:
            message_parts.append(current_message.strip())
        return message_parts
    else:
        return [message.strip()]
    
def send_to_csound(message):
	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	#s.setsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF, 65536)

	#max_size = s.getsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF)
	#log("Max datagram size: " + str(max_size))
	#log(len(action))
	max_size = 4096
	messages = split_message(message, max_size)
	for message_part in messages:
		s.sendto(message_part.encode(), ('localhost', 10025))

	s.close()

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

	def __init__(self, index, track_id, item_id, take_id):

		self.name = None
		self.start = None
		self.dur = None
		self.dyn = None
		self.env = 'classic'
		self.text = None

		note_index = index
		ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_velocity = RPR_MIDI_GetNote(take_id, note_index, 0, 0, 0, 0, 0, 0, 0)

		ppqdur = endppqposOut-startppqposOut
		name = str(RPR_GetTrackMIDINoteNameEx(0, track_id, note_pitch, note_chn))

		self.name = re.search(r'c.\s+(.*)', name)[1]
		self.start = RPR_MIDI_GetProjTimeFromPPQPos(take_id, startppqposOut)
		self.dur = RPR_MIDI_GetProjTimeFromPPQPos(take_id, ppqdur)
		self.dyn = float(note_velocity)/MIDI_CORRECTION	

		retval, meditem, parname, text, var = RPR_GetSetMediaItemInfo_String(item_id, 'P_NOTES', 0, 0)
		if text:
			for line in text.splitlines():
				if line.startswith('dur'):
					val = line.split('dur')[1]
					self.dur = eval(f'{self.dur}{val}')
				elif line.startswith('dyn'):
					val = line.split('dyn')[1]
					self.dyn = eval(f'{self.dyn}{val}')
				elif line.startswith('env'):
					val = line.split('env')[1].strip()
					#log(val)
					self.env = val


		text_retval, take, textsyxevtidx, selectedOutOptional, mutedOutOptional, ppqposOutOptional, typeOutOptional, msgOptional, msgOptional_sz = RPR_MIDI_GetTextSysexEvt(take_id, note_index, 0, 0, 0, 0, 0, 512)
		if text_retval:
			# i don't know why, but i need to remove 2 character from the end of the text string
			self.env = msgOptional[:-2:]




def get_score():
	main_index = 0
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
							midi = CORDELIA_midi(index, track.id, item.id, item.take_id)
							init_round = 5
							NAMED_INSTR.append(track.parent_name)
							csound_code = f'eva_midi "{track.parent_name}", {round(midi.start-current_pos, init_round)}, {round(midi.dur-item.start_pos-current_pos, init_round)}, {round(midi.dyn, init_round)}, {midi.env}, {midi.name}'
							CORDELIA_SEND_INSTR.append(csound_code)
							if track.parent_name not in TURNOFF_NAME:
								TURNOFF_NAME.append(track.parent_name)

					elif item.source_type == 'SCORE':
						score = CORDELIA_score(item.id)
						#index_par = score.text.find('(')
						#opcode_name = score.text[:index_par]
						#opcode_params = score.text[index_par+1:-1]

						instr_num = instr_start_num + main_index
						TURNOFF_NUM.append(f'turnoff2 {str(instr_num)}, 0, 0')

						score_core = re.sub(r"'", '"', score.text)

						if track.name == 'ROUTE':
							lines = score_core.splitlines()
							opcode_name = lines[0]
							opcode_params = ', '.join(lines[1:])
							csound_code = f'''
	instr {instr_num}
{opcode_name}("{track.parent_name}", {opcode_params})
	endin	
	schedule {instr_num}, {item.start_pos}, {item.length}
'''
							CORDELIA_SEND_INSTR.append(csound_code)
							main_index += 1
						else:
							csound_code = f'''
	instr {instr_num}
{score_core}
	endin	
	schedule {instr_num}, {item.start_pos}, {item.length}
'''
							CORDELIA_SEND_INSTR.append(csound_code)
							main_index += 1

reaper_play = False
instr_start_num = 700
CORDELIA_SEND_INSTR = []
TURNOFF_NUM =[]
TURNOFF_NAME = []

def on_play():
	global CORDELIA_SEND_INSTR, CSOUND_STRINGS

	get_score()

	#send_to_csound('schedule "heart", 0, -1')
	CSOUND_STRINGS.append('schedule "heart", 0, -1')
	CSOUND_STRINGS.extend(CORDELIA_SEND_INSTR)
	send_to_csound('\n'.join(CSOUND_STRINGS))
	CSOUND_STRINGS.clear()

def on_stop():
	global TURNOFF_NUM, TURNOFF_NAME, CSOUND_STRINGS, NAMED_INSTR

	#send_to_csound('turnoff2_i "heart", 0, 0')
	CSOUND_STRINGS.append('turnoff2_i "heart", 0, 0')

	turnoff_list = []
	for each in TURNOFF_NAME:
		turnoff_list.append(f'turnoff3 nstrnum("{each}")')
		turnoff_list.append(f'turnoff2 nstrnum("{each}"), 0, 0')

	string = '\n'.join(TURNOFF_NUM + turnoff_list)

	NAMED_INSTR = list(dict.fromkeys(NAMED_INSTR))

	for each in NAMED_INSTR:
		CSOUND_STRINGS.append(f'turnoff3 nstrnum("{each}")')

	CSOUND_STRINGS.append(f'''
		instr 865
{string}
	turnoff
		endin
		schedule 865, 0, 1''')

	send_to_csound('\n'.join(CSOUND_STRINGS))

	CORDELIA_SEND_INSTR.clear()
	TURNOFF_NUM.clear()
	TURNOFF_NAME.clear()
	CSOUND_STRINGS.clear()
	NAMED_INSTR.clear()

def check_play():

	global reaper_play
	
	if RPR_GetPlayState()==1 and not reaper_play:
		on_play()
		reaper_play = True
	elif RPR_GetPlayState()==0 and reaper_play:
		on_stop()
		reaper_play = False

	RPR_defer('check_play()')


check_play()