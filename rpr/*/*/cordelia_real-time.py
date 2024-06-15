import re, socket
from dataclasses import dataclass
import rtmidi

BUFFER_SIZE = 1024 * 1024
MIDI_CORRECTION = 1024

midi_in = rtmidi.RtMidiIn()

@dataclass
class Midi_note:
	start_pos: float
	end_pos: float
	unique_index: int
	instr_name: str
	dur: float
	dyn: float
	env: str
	freq: float

@dataclass
class Text_item:
	start_pos: float
	end_pos: float
	unique_index: int
	instr_name: str
	text: str
	dur: float
	
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

def send_to_csound(message):
    global s
    s.sendto(message.encode(), ('localhost', 10025))

def log(string):
	RPR_ShowConsoleMsg(str(string) + '\n')

def extract_elements(string):
    elements = []
    paren_count = 0
    start = 0
    for i, c in enumerate(string):
        if c == '(':
            paren_count += 1
        elif c == ')':
            paren_count -= 1
        elif c == ',' and paren_count == 0:
            elements.append(string[start:i])
            start = i + 1
    elements.append(string[start:])
    return [elem.strip() for elem in elements if elem]

def decode_midi_message(message):
	status_byte = message.getRawData()[0]
	message_type = (status_byte & 0xF0) >> 4

	if message_type == 0x9:  # Note on message
		pitch =  message.getRawData()[1]
		velocity =  message.getRawData()[2]

		return [pitch, velocity]

def midi_in_play():
	global midi_in
	# Loop forever, printing incoming MIDI messages
	message = midi_in.getMessage()
	if message:
		note = decode_midi_message(message)
		if note:
			csound_string = f'eva_midi "ixland", 0, 1, {note[1]/MIDI_CORRECTION}, classic, mtof:i({note[0]})'
			send_to_csound(csound_string)

	RPR_defer('midi_in_play()')



def get_item():

	midi_notes = []
	text_items = []
	
	unique_index_note = 0
	unique_index_text = 0

	for i in range(RPR_CountTracks(0)):

		track_id = RPR_GetTrack(0, i)
		is_child = RPR_GetMediaTrackInfo_Value(track_id, 'I_FOLDERDEPTH')
		#log(is_child)

		if is_child==1:
			is_mute = bool(RPR_GetMediaTrackInfo_Value(track_id, 'B_MUTE'))
			if RPR_AnyTrackSolo(0):
				is_solo = bool(RPR_GetMediaTrackInfo_Value(track_id, 'I_SOLO') > 0)

			retval, meditem, parname, parent_name, var = RPR_GetSetMediaTrackInfo_String(track_id, 'P_NAME', 0, 0)
			#log(parent_name)
			instr_name = parent_name

		for j in range (RPR_GetTrackNumMediaItems(track_id)):
			item_id = RPR_GetTrackMediaItem(track_id, j)
			take_id = RPR_GetMediaItemTake(item_id, 0)
	
			if RPR_TakeIsMIDI(take_id):
				ret_val, ret_take, notecntOut, ret_cc, ret_sysex = RPR_MIDI_CountEvts(take_id, 0, 0, 0)
				for note_index in range(notecntOut):
					ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_velocity = RPR_MIDI_GetNote(take_id, note_index, 0, 0, 0, 0, 0, 0, 0)
					text_retval, take, textsyxevtidx, selectedOutOptional, mutedOutOptional, ppqposOutOptional, typeOutOptional, msgOptional, msgOptional_sz = RPR_MIDI_GetTextSysexEvt(take_id, note_index, 0, 0, 0, 0, 0, BUFFER_SIZE)
				

					start_pos = RPR_MIDI_GetProjTimeFromPPQPos(take_id, startppqposOut)
					end_pos = RPR_MIDI_GetProjTimeFromPPQPos(take_id, endppqposOut)
					
					dur = end_pos - start_pos
					dyn = note_velocity / MIDI_CORRECTION

					freq = str(RPR_GetTrackMIDINoteNameEx(0, track_id, note_pitch, note_chn))
					freq = re.search(r'c.\s+(.*)', freq)[1]

					env = 'classic'

					retval, meditem, parname, text, var = RPR_GetSetMediaItemInfo_String(item_id, 'P_NOTES', 0, 0)
					if text:
						for line in text.splitlines():
							if line.startswith('dur'):
								val = line.split('dur')[1]
								dur = eval(f'{dur}{val}')
							elif line.startswith('dyn'):
								val = line.split('dyn')[1]
								dyn = eval(f'{dyn}{val}')
							elif line.startswith('env.'):
								val = line.split('env.')[1].strip()
								env = val

					if text_retval:
						# i don't know why, but i need to remove 2 character from the end of the text string
						env = msgOptional[:-2:]
						
					midi_note = Midi_note(start_pos, end_pos, unique_index_note, instr_name, dur, dyn, env, freq)

					midi_notes.append(midi_note)
					unique_index_note += 1
			else:
				source, source_type, size = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(take_id), '', BUFFER_SIZE)
				if not source_type:
					retval, meditem, parname, text, var = RPR_GetSetMediaItemInfo_String(item_id, 'P_NOTES', 0, 0)
					start_pos = RPR_GetMediaItemInfo_Value(item_id, 'D_POSITION')
					dur = RPR_GetMediaItemInfo_Value(item_id, 'D_LENGTH')
					end_pos = start_pos+dur
					
					text_item = Text_item(start_pos, end_pos, unique_index_text, instr_name, text, dur)
					
					text_items.append(text_item)
					unique_index_text += 1
	
	midi_notes = sorted(midi_notes, key=lambda note: note.start_pos)
	text_items = sorted(text_items, key=lambda item: item.start_pos)

	return midi_notes, text_items



midi_notes = []
text_items = []

last_seen_note = []
last_seen_text_on = []
last_seen_text_off = []
last_seen_text_left = []

play_state = True

def main():

	global play_state
	global midi_notes, text_items
	global last_seen_note, last_seen_text_on, last_seen_text_off, last_seen_text_left


	if RPR_GetPlayState() == 1:

		if play_state:
			midi_notes, text_items = get_item()
			play_pos = RPR_GetCursorPosition()
			for note in midi_notes:
				if note.start_pos >= play_pos:
					break
				if note not in last_seen_note:
					last_seen_note.append(note)
			send_to_csound('schedule "heart", 0, -1')
			play_state = False

		play_pos = RPR_GetPlayPosition()

		for note in midi_notes:
			if note.start_pos >= play_pos:
				break
			if note not in last_seen_note:
				csound_string = f'eva_midi "{note.instr_name}", 0, {note.dur}, {note.dyn}, {note.env}, {note.freq}'
				send_to_csound(csound_string)
				#log(csound_string)
				last_seen_note.append(note)

		for item in text_items:
			if item.start_pos >= play_pos:
				break
			if item not in last_seen_text_on:
				score = extract_elements(item.text)
				score.insert(1, f'"{item.instr_name}"')
				score = ', '.join(score)
				csound_string = f'instr {int(item.unique_index + 300)}\n{score}\nendin\n'
				csound_string += f'schedule {int(item.unique_index + 300)}, 0, -1'
				send_to_csound(csound_string)
				last_seen_text_on.append(item)
				last_seen_text_left.append(item)

		for item in last_seen_text_on:
			if play_pos <= item.end_pos:
				break
			if item not in last_seen_text_off:
				csound_string = f'turnoff2_i {int(item.unique_index + 300)}, 4, 0'
				send_to_csound(csound_string)
				last_seen_text_off.append(item)
				last_seen_text_left.remove(item)


	if RPR_GetPlayState() == 0:
		if not play_state:

			for item in last_seen_text_left:
				csound_string = f'turnoff2_i {int(item.unique_index + 300)}, 4, 0'
				send_to_csound(csound_string)

				midi_notes = []
				text_items = []
				last_seen_note = []
				last_seen_text_on = []
				last_seen_text_off = []
				last_seen_text_left = []


			send_to_csound('turnoff2_i "heart", 0, 0')
			
			play_state = True

	RPR_defer('main()')

""" if midi_in.isPortOpen(1):
	midi_in.openPort(1)
	midi_in_play() """

main()