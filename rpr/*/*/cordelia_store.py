import json, subprocess, re
from dataclasses import dataclass

BUFFER_SIZE = 1024 * 1024
MIDI_CORRECTION = 1024

CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIA'

project_folder, buf_size = RPR_GetProjectPath("", 512)
project_folder = project_folder + '/'

project_num, project_name_ext, buf_size = RPR_GetProjectName(0, "", 512)
project_name = project_name_ext.rsplit(".", 1)[0]

ORC_FILE = project_folder + project_name + '.orc'
LOG_FILE = project_folder + project_name + '.log'
WAV_FILE = project_folder + project_name + '.wav'

with open(CORDELIA_DIR + '/_setting' + '/instr.json') as f:
	CORDELIA_INSTR_json = json.load(f)

with open(CORDELIA_DIR + '/_setting' + '/gen.json') as f:
	CORDELIA_GEN_json = json.load(f)

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

def check_track_state(id):


def get_item():

	midi_notes = []
	text_items = []
	
	unique_index_note = 0
	unique_index_text = 0

	parent_mute = False
	parent_solo = False

	for i in range(RPR_CountTracks(0)):

		track_id = RPR_GetTrack(0, i)
		is_child = RPR_GetMediaTrackInfo_Value(track_id, 'I_FOLDERDEPTH')

		if is_child==1:
			#B_MUTE : bool * : muted
			parent_mute = RPR_GetMediaTrackInfo_Value(track_id, 'B_MUTE')
			
			if RPR_AnyTrackSolo(0):
				#I_SOLO : int * : soloed, 0=not soloed, 1=soloed, 2=soloed in place, 5=safe soloed, 6=safe soloed in place
				parent_solo = bool(RPR_GetMediaTrackInfo_Value(track_id, 'I_SOLO') > 0)
		
		child_mute = RPR_GetMediaTrackInfo_Value(track_id, 'B_MUTE')

		if not parent_mute and not parent_solo and not child_mute:
			if is_child <= 0:
				retval, meditem, parname, parent_name, var = RPR_GetSetMediaTrackInfo_String(RPR_GetParentTrack(track_id), 'P_NAME', 0, 0)
				instr_name = re.match(r'@\w+', str(parent_name))[0]
				dict_name = instr_name + f'_{i}'

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
						
						dur = end_pos - start_pos
						dyn = note_velocity / MIDI_CORRECTION

						freq = str(RPR_GetTrackMIDINoteNameEx(0, track_id, note_pitch, note_chn))
						freq = re.search(r'c.\s+(.*)', freq)[1]

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

def remove_escape_codes(input_file, output_file):
    with open(input_file, 'r') as f_in:
        with open(output_file, 'w') as f_out:
            for line in f_in:
                line = re.sub(r'\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]', '', line)
                f_out.write(line)

def main():

	lines = []

	instrs = set()
	gens = set()

	includes = [CORDELIA_DIR + '/_core/setting.orc']

	with open(CORDELIA_DIR + '/_core/include.orc') as f:
		for line in f:
			path = line.strip().replace('"', '').replace('#include ', '')
			includes.append(path)

	midi_notes, text_items = get_item()

	proj_len = RPR_GetProjectLength(0) + 1
	lines.append(f'schedule "heart", 0, {proj_len}')
	lines.append('\tinstr end_score\nevent "e", 0, .025\n\tendin')
	lines.append(f'\tschedule "end_score", {proj_len}, .025')

	for note in midi_notes:
		removed_name = (note.instr_name).replace('@', '')
		replace_env = note.env.replace('.a', '$atk')
		prefix_env = 'gi' + replace_env
		if note.start_pos < 0:
			log('WARNING: some notes starts before 0, I just set them to 0!')
			note.start_pos = 0
		csound_string = f'eva_midi "{removed_name}", {note.start_pos}, {note.dur}, {note.dyn}, {prefix_env}, {note.freq}'
		lines.append(csound_string)
		instrs.add(removed_name)
		gens.add(replace_env)
	
	for i, instr in enumerate(instrs):
		path = CORDELIA_INSTR_json[instr]['path']
		if type(path) == list:
			for p in path:
				includes.append(p)
				#log(p)
		else:	
			includes.append(path)

		lines.append(';---')

		lines.append(f'gS{instr}[] init ginchnls')

		lines.append('indx	init 0')
		lines.append('until	indx == ginchnls do')
		lines.append(f'	gS{instr}[indx] sprintf "{instr}_%i", indx+1')
		lines.append(f'	isend	= 950 + (indx+1)/1000 + {i}/10000')
		lines.append(f'	schedule isend, 0, -1, sprintf("{instr}_%i", indx+1)')
		lines.append('	indx	+= 1')
		lines.append('od')

	for gen in gens:
		if '$' in gen:
			gen = gen.split('$')[0]
		includes.append(CORDELIA_GEN_json[gen])

	for item in text_items:
		removed_name = (item.instr_name).replace('@', '')
		score = extract_elements(item.text)
		score.insert(1, f'"{removed_name}"')
		score = ', '.join(score)
		csound_string = f'\tinstr {int(item.unique_index + 300)}\n{score}\n\tendin\n'
		csound_string += f'schedule {int(item.unique_index + 300)}, {item.start_pos}, {item.end_pos}'
		lines.append(csound_string)

	with open(ORC_FILE, 'wb') as main_orc:
		for include in includes:
			#log(include.split('.')[-1])
			if include.split('.')[-1] == 'orc':
				with open(include, 'rb') as f:
					main_orc.write(f';{include}\n'.encode('utf-8'))
					main_orc.write(f';---\n'.encode('utf-8'))
					content = f.read()
					main_orc.write(content)
			else:
				pass
				#log(include)
				#main_orc.write(f'#include "{include}"'.encode('utf-8'))


		main_orc.write('\n'.join(lines).encode('utf-8'))


retval, title, num_inputs, captions_csv, retvals_csv, retvals_csv_sz = RPR_GetUserInputs('Render with', 3, 'channels, sample rate, ksmps', '2, 48, 16', 512)

if retval:

	main()
	
	values = retvals_csv.split(', ')
	chns = values[0]
	sr = int(values[1]) * 1000
	ksmps = values[2]

	command = f'csound -3 --nchnls={chns} -r {sr} --ksmps={ksmps} --orc {ORC_FILE} -o {WAV_FILE} &> {LOG_FILE}'

	#subprocess.call(['osascript', '-e', f'tell application "Terminal" to do script "{command}"'])
	script = f'tell application "Terminal" to do script "{command} && exit"'
	subprocess.call(['osascript', '-e', script])

	# Wait for the command to finish
	p = subprocess.Popen(command, shell=True)
	p.wait()

	# Check the exit status
	if p.returncode == 0:
		string = 'Command completed successfully!'
		print(string)
	else:
		string = f'Command failed with exit code {p.returncode}.'
	
	remove_escape_codes(LOG_FILE)
