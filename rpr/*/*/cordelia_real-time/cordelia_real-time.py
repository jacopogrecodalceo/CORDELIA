import socket, re

# ============= VAR =============

MIDI_CORRECTION = 512
STATE = True
LAST_PLAY_POS = 0
# ============= UTILITY =============

# Create a socket object
udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Define the server address and port
server_address = ('localhost', 10025)

def send_to_cordelia(message):
	log(message)
	udp_socket.sendto(message.encode(), server_address)  # Encode the string to bytes before sending

def log(string):
	RPR_ShowConsoleMsg(str(string) + '\n')

def extract_comma_elements(string):
	elements = []
	paren_count = 0
	start = 0
	for i in range(len(string)):
		c = string[i]
		if c == '(':
			paren_count += 1
		elif c == ')':
			paren_count -= 1
		elif c == ',' and paren_count == 0:
			elements.append(string[start + 1:i])
			start = i
	elements.append(string[start + 1:])
	result = []
	for elem in elements:
		elem = elem.strip()  # remove leading/trailing whitespace
		if len(elem) > 0:
			result.append(elem)
	return result

def evaluate_track_name(info, dur, dyn, env):
	for word in extract_comma_elements(info):
		if word.startswith('dur'):
			dur = eval(word)
		elif word.startswith('dyn'):
			dyn = eval(word)
		elif word.startswith('env.'):
			val = re.search('env\.(.*)', word).group(1)
			env = val
	return dur, dyn, env

# ============= REAPER FUNCTIONS =============

class Item():
	pass

def get_tracks():
	tracks = []
	i = 0

	while i < RPR_CountTracks(0):

		track = RPR_GetTrack(0, i)
		is_parent = RPR_GetMediaTrackInfo_Value(track, 'I_FOLDERDEPTH') == 1
		is_solo = RPR_GetMediaTrackInfo_Value(track, 'I_SOLO') > 0
		is_mute = RPR_GetMediaTrackInfo_Value(track, 'B_MUTE') == 1

		if RPR_AnyTrackSolo(0):
			if is_solo and is_parent:
				for j in range(i + 1, RPR_CountTracks(0)):
					sub_track = RPR_GetTrack(0, j)
					track_depth = RPR_GetMediaTrackInfo_Value(sub_track, 'I_FOLDERDEPTH')
					if track_depth == 1:
						i = j  # Set the outer loop index to continue from here
						break
					else:
						tracks.append(sub_track)
		else:
			if is_mute and is_parent:
				for j in range(i + 1, RPR_CountTracks(0)):
					sub_track = RPR_GetTrack(0, j)
					track_depth = RPR_GetMediaTrackInfo_Value(sub_track, 'I_FOLDERDEPTH')
					if track_depth == 1 or j == RPR_CountTracks(0)-1:
						i = j  # Set the outer loop index to continue from here
						break
			elif not is_mute:
				tracks.append(track)

		i += 1

	return tracks

def get_notes_and_scores():
	tracks = get_tracks()

	notes = []
	scores = []

	index = 0

	parent_track_name = None
	
	for track in tracks:
		track_depth = RPR_GetMediaTrackInfo_Value(track, 'I_FOLDERDEPTH')
		track_num = int(RPR_GetMediaTrackInfo_Value(track, 'IP_TRACKNUMBER'))

		# If depth == 1, it's a parent track
		if track_depth == 1:
			_, _, _, parent_track_name, _ = RPR_GetSetMediaTrackInfo_String(track, 'P_NAME', '', False)

			if '@' not in parent_track_name:
				error = 'No instrument name in track name'
				log(error)
				return False, None, None

		for j in range(RPR_GetTrackNumMediaItems(track)):
			item = RPR_GetTrackMediaItem(track, j)
			take = RPR_GetMediaItemTake(item, 0)
			_, item_type, _ = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(take), '', 512)
			item_type = item_type if item_type else 'SCORE'
			_, _, _, track_name, _ = RPR_GetSetMediaTrackInfo_String(track, 'P_NAME', '', False)

			item_start_pos = RPR_GetMediaItemInfo_Value(item, 'D_POSITION')
			dur = RPR_GetMediaItemInfo_Value(item, 'D_LENGTH')
			item_end_pos = item_start_pos + dur
			instrument_name = parent_track_name
			info = track_name

			if item_type == 'MIDI':

				try:
					tuning_freq_list = [re.search('c\s+(.*)', RPR_GetTrackMIDINoteNameEx(0, track, p, 0)).group(1) for p in range(128)]
				except:
					error = f'No tuning system in {instrument_name} track {track_num}'
					log(error)
					return False, None, None
				
				_, _, note_count, _, _ = RPR_MIDI_CountEvts(take, 0, 0, 0)

				for i in range(note_count):
					_, _, _, _, _, startppqpos, endppqpos, _, pitch, vel = RPR_MIDI_GetNote(take, i, 0, 0, 0, 0, 0, 0, 0)

					onset = max(0, RPR_MIDI_GetProjTimeFromPPQPos(take, startppqpos))
					end_pos = RPR_MIDI_GetProjTimeFromPPQPos(take, endppqpos)

					if onset <= item_end_pos and onset >= item_start_pos:

						dur = end_pos - onset
						dyn = vel / MIDI_CORRECTION
						env = 'classic'

						dur, dyn, env = evaluate_track_name(info, dur, dyn, env)

						note = (
							onset,
							end_pos,
							instrument_name,
							dur,
							dyn,
							env,
							tuning_freq_list[pitch]
						)

						notes.append(note)

			if item_type == 'SCORE':

				_, _, _, code, _ = RPR_GetSetMediaItemInfo_String(item, 'P_NOTES', '', False)
				code = re.sub(r'\bp3\b', str(dur), code)

				score = (
					item_start_pos,
					item_end_pos,
					instrument_name,
					dur,
					code,
					index
				)
				scores.append(score)
				index += 1

	return True, notes, scores

# ============= REAL-TIME =============

def remove_at_play(notes, scores):

	play_pos = RPR_GetCursorPosition()

	for i, note in enumerate(notes):
		onset = note[0]
		if onset >= play_pos:
			notes = notes[i:]
			break
	
	scores = [item for item in scores if item[0] >= play_pos or item[1] >= play_pos]

	return notes, scores

def on_play():

	global STATE, LAST_PLAY_POS
	
	LAST_PLAY_POS = RPR_GetPlayPosition()

	result, notes, scores = get_notes_and_scores()

	if result:
		if len(notes) > 15000:
			RPR_CSurf_OnStop()
			log('Items are more than 150000')

		notes, scores = remove_at_play(notes, scores)
		send_to_cordelia('schedule "heart", 0, -1')
		
		STATE = False

		return notes, scores

def on_stop(score_turnoff):

	global STATE
	
	send_to_cordelia('turnoff2_i "heart", 0, 0')

	if score_turnoff:
		for item in score_turnoff:
			instr_num = str(item[5] + 300)
			send_to_cordelia(f'turnoff2_i {instr_num}, 0, 0')

	score_turnoff = []
	STATE = True

notes = []
scores = []

def cordelia_realtime():

	global LAST_PLAY_POS, notes, scores

	score_turnoff = []

	if RPR_GetPlayState() == 1:
		if STATE:
			notes, scores = on_play()
		
		play_pos = RPR_GetPlayPosition()
		if play_pos - LAST_PLAY_POS > 1:
			RPR_CSurf_OnStop()

		LAST_PLAY_POS = play_pos

		index = 0
		while index < len(notes):
			note = notes[index]
			onset = note[0]

			""" note = (
				onset,
				end_pos,
				instrument_name,
				dur,
				dyn,
				env,
				tuning_freq_list[pitch]
			) """

			if onset <= play_pos:
				instrument_name, dur, dyn, env, freq = note[2], note[3], note[4], note[5], note[6]
				csound_string = f'eva_midi "{instrument_name}", 0, {dur}, {dyn}, {env}, {freq}'
				send_to_cordelia(csound_string)
				notes.pop(index)
			else:
				index += 1

		index = 0
		while index < len(scores):

			""" score = (
				item_start_pos,
				item_end_pos,
				instrument_name,
				dur,
				code
			) """

			score = scores[index]
			onset = score[0]
			instr_num = str(score[5] + 300)

			if onset <= play_pos:
				instrument_name = score[2]
				text = score[4]
				code = extract_comma_elements(text)

				if instrument_name == '@cordelia':
					csound_string = f'instr {instr_num}\n{text}\nendin\n'
					csound_string = f'{csound_string}schedule {instr_num}, 0, -1'
					send_to_cordelia(csound_string)
					score_turnoff.append(score)
					scores.pop(index)
				else:
					code.insert(1, f'"{instrument_name}"')
					csound_string = f'instr {instr_num}\n{", ".join(code)}\nendin\n'
					csound_string = f'{csound_string}schedule {instr_num}, 0, -1'
					send_to_cordelia(csound_string)
					score_turnoff.append(score)
					scores.pop(index)
			else:
				index += 1

		if score_turnoff:
			index = 0
			while index < len(score_turnoff):
				score = score_turnoff[index]
				end_pos = score[1]
				instr_num = str(score[5] + 300)

				if end_pos <= play_pos:
					csound_string = f'turnoff2_i {instr_num}, 0, 0'
					send_to_cordelia(csound_string)
					score_turnoff.pop(index)
				else:
					index += 1

	elif RPR_GetPlayState() == 0:
		if not STATE:
			on_stop(score_turnoff)

def main():
	cordelia_realtime()
	RPR_defer('main()')

# ============= MAIN =============

RPR_defer('main()')

