import re, socket
from dataclasses import dataclass, field

BUFFER_SIZE = 1024 * 1024
MIDI_CORRECTION = 1024


@dataclass
class Midi_note:
	start_pos: float
	end_pos: float
	unique_index: int
	instr_name: str
	vel: int
	env: str
	freq: float
	dur: float = field(init=False)
	dyn: float = field(init=False)

	def __post_init__(self):
		object.__setattr__(self, 'dur', self.end_pos - self.start_pos)
		object.__setattr__(self, 'dyn', self.vel / MIDI_CORRECTION)

	def __lt__(self, other):
		return self.start_pos < other.start_pos

@dataclass
class Text_item:
	start_pos: float
	end_pos: float
	text: str
	

def send_to_csound(message):
	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	#s.setsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF, 65536)
	#max_size = s.getsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF)
	#log("Max datagram size: " + str(max_size))
	#log(len(action))
	s.sendto(message.encode(), ('localhost', 10025))
	#s.close()

def log(string):
	RPR_ShowConsoleMsg(str(string) + '\n')

def midi2freq_edo12(note):
	A4 = 440
	return (2^((note-69)/12)) * A4

midi_table = []
text_table = []

def get_item():

	global midi_table, text_table
	unique_index = 0

	for i in range(RPR_CountTracks(0)):
		track_id = RPR_GetTrack(0, i)
	
		for j in range (RPR_GetTrackNumMediaItems(track_id)):
			item_id = RPR_GetTrackMediaItem(track_id, j)
			take_id = RPR_GetMediaItemTake(item_id, 0)
	
			if RPR_TakeIsMIDI(take_id):
				ret_val, ret_take, notecntOut, ret_cc, ret_sysex = RPR_MIDI_CountEvts(take_id, 0, 0, 0)
				for note_index in range(notecntOut):
					ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_velocity = RPR_MIDI_GetNote(take_id, note_index, 0, 0, 0, 0, 0, 0, 0)
					text_retval, take, textsyxevtidx, selectedOutOptional, mutedOutOptional, ppqposOutOptional, typeOutOptional, msgOptional, msgOptional_sz = RPR_MIDI_GetTextSysexEvt(take_id, note_index, 0, 0, 0, 0, 0, BUFFER_SIZE)
					
					if text_retval:
						# i don't know why, but i need to remove 2 character from the end of the text string
						env = msgOptional[:-2:]
					else:
						env = 'classic'

					start_pos = RPR_MIDI_GetProjTimeFromPPQPos(take_id, startppqposOut)
					end_pos = RPR_MIDI_GetProjTimeFromPPQPos(take_id, endppqposOut)
					
					retval, meditem, parname, parent_name, var = RPR_GetSetMediaTrackInfo_String(RPR_GetParentTrack(track_id), 'P_NAME', 0, 0)
					if parent_name:
						instr_name = re.match(r'@\w+', str(parent_name))[0]

					vel = note_velocity

					freq = str(RPR_GetTrackMIDINoteNameEx(0, track_id, note_pitch, note_chn))
					freq = re.search(r'c.\s+(.*)', freq)[1]
					unique_index = unique_index

					midi_note = Midi_note(start_pos, end_pos, unique_index, instr_name, vel, env, freq)

					midi_table.append(midi_note)
					unique_index += 1
			else:
				source, source_type, size = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(take_id), '', BUFFER_SIZE)
				if not source_type:
					retval, meditem, parname, text, var = RPR_GetSetMediaItemInfo_String(item_id, 'P_NOTES', 0, 0)
					text_start_pos = RPR_GetMediaItemInfo_Value(item_id, 'D_POSITION')
					dur = RPR_GetMediaItemInfo_Value(item_id, 'D_LENGTH')
					
					text_item = Text_item(text_start_pos, dur, text)
					
					text_table.append(text_item)
	
	midi_table = sorted(midi_table, key=lambda note: note.start_pos)



last_seen = []

play_state = True

def on_play():
	global play_state
	get_item()
	play_state = False

def on_stop():
	global play_state
	global midi_table, text_table, last_seen
	for each in [midi_table, text_table, last_seen]:
		each.clear()
	play_state = True


import bisect

last_index = 0  # initialize the last index of the note that was processed
PROCESSING_WINDOW =  1

def process_notes(midi_table, play_pos, last_seen):
    global last_index  # allow access to the global variable

    # find the index of the first note that is outside the time range of interest
    end_pos = play_pos + PROCESSING_WINDOW
    end_note = Midi_note(end_pos, -1, "", 0, 0, 0, 0) # create a dummy note with end_pos as start_pos
    end_index = bisect.bisect_left(midi_table, end_note)

    # iterate through the notes that are still within the time range of interest
    for note in midi_table[last_index:end_index]:
        csound_string = f'eva_midi "{note.instr_name}", 0, {note.dur}, {note.dyn}, {note.env}, {note.freq}'
        send_to_csound(csound_string)
        #log(csound_string)
        last_seen.append(note)

    last_index = end_index  # update the last index of the note that was processed


def main():

	global play_state
	global midi_table, text_table, last_seen
	
	if RPR_GetPlayState() == 1:
		
		if play_state:
			on_play()
			#log('playing...')

		play_pos = RPR_GetPlayPosition()
		#log(play_pos)

		process_notes(midi_table, play_pos, last_seen)

	if RPR_GetPlayState() == 0:
		if not play_state:
			on_stop()
			#log('stopped')

	RPR_defer('main()')


main()