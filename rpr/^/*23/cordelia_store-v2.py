import json, subprocess, re, os, shutil

BUFFER_SIZE = 1024 * 1024
MIDI_CORRECTION = 1024

CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIA'
MAIN_TRACK_NAME = '_main'

SONVS_SUCCESS = '/Users/j/Documents/script/OOT_Get_Heart.wav'
SONVS_ERROR = '/Users/j/Documents/script/OOT_Navi_WatchOut1.wav'

project_dir, buf_size = RPR_GetProjectPath("", 512)
project_dir = project_dir + '/'

project_num, project_name_ext, buf_size = RPR_GetProjectName(0, "", 512)
project_name = project_name_ext.rsplit(".", 1)[0]

tracks_dir = project_dir + '_renders/'
render_dir = project_dir + f'{project_name}-cordelia_render/'
main_track_dir = project_dir + f'tracks/{MAIN_TRACK_NAME}'



with open(CORDELIA_DIR + '/_setting' + '/instr.json') as f:
	CORDELIA_INSTR_json = json.load(f)

with open(CORDELIA_DIR + '/_setting' + '/gen.json') as f:
	CORDELIA_GEN_json = json.load(f)

class Item:
	def __init__(self, type, track_id, item_id, take_id, instr_name, dict_name):
		self.type = type
		self.track_id = track_id
		self.item_id = item_id
		self.take_id = take_id
		self.instr_name = instr_name
		self.dict_name = dict_name

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


def check_if_additional_text(item):
	#retval, meditem, parname, text, var = RPR_GetSetMediaItemInfo_String(item.item_id, 'P_NOTES', 0, 0)
	retval, meditem, parname, track_name, var = RPR_GetSetMediaTrackInfo_String(item.track_id, 'P_NAME', 0, 0)
	text = track_name
	for line in extract_elements(text):
		if line.startswith('dur'):
			val = line.split('dur')[1]
			item.dur = eval(f'{item.dur}{val}')
		elif line.startswith('dyn'):
			val = line.split('dyn')[1]
			item.dyn = eval(f'{item.dyn}{val}')
		elif line.startswith('freq'):
			val = line.split('freq')[1]
			item.freq = eval(f'{item.freq}{val}')
		elif line.startswith('env.'):
			val = line.split('env.')[1].strip()
			item.env = val



def get_midi_note_env_if_text(item):
	text_retval, take, textsyxevtidx, selectedOutOptional, mutedOutOptional, ppqposOutOptional, typeOutOptional, msgOptional, msgOptional_sz = RPR_MIDI_GetTextSysexEvt(item.take_id, 0, 0, 0, 0, 0, 0, BUFFER_SIZE)
	
	epsilon = 15 #Adjust the epsilon value based on your desired precision
	difference = abs(item.startppq_pos - ppqposOutOptional)
	
	if text_retval and difference < epsilon:
		# i don't know why, but i need to remove 2 character from the end of the text string
		if msgOptional.strip() != '':
			item.env = msgOptional[:-2:]
			#log(msgOptional)
		
def get_midi_note_freq(item):
	freq = str(RPR_GetTrackMIDINoteNameEx(0, item.track_id, item.midi_pitch, item.midi_chn))
	item.freq = re.search(r'c.\s+(.*)', freq)[1]



def get_midi_notes(item):

	take_id = item.take_id

	ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_velocity = RPR_MIDI_GetNote(take_id, item.note_index, 0, 0, 0, 0, 0, 0, 0)

	item.midi_pitch = note_pitch
	item.midi_chn = note_chn

	item.startppq_pos = startppqposOut
	item.start_pos = RPR_MIDI_GetProjTimeFromPPQPos(take_id, startppqposOut)
	item.end_pos = RPR_MIDI_GetProjTimeFromPPQPos(take_id, endppqposOut)

	item.dur = item.end_pos - item.start_pos
	item.dyn = note_velocity / MIDI_CORRECTION
	item.env = 'classic'
	get_midi_note_freq(item)
	check_if_additional_text(item)
	get_midi_note_env_if_text(item)

	return item

def get_empty_items(item):
		item_id = item.item_id
		retval, meditem, parname, text, var = RPR_GetSetMediaItemInfo_String(item_id, 'P_NOTES', 0, 0)
		item.start_pos = RPR_GetMediaItemInfo_Value(item_id, 'D_POSITION')
		item.dur = RPR_GetMediaItemInfo_Value(item_id, 'D_LENGTH')
		item.end_pos = item.start_pos + item.dur
		item.text = text

		return item


def get_all_items():

	items = []
	
	num_tracks = RPR_CountTracks(0)
	for i in range(num_tracks):

		track_id = RPR_GetTrack(0, i)
		is_child = bool(RPR_GetMediaTrackInfo_Value(track_id, 'I_FOLDERDEPTH') <= 0)

		if not is_child:
			retval, meditem, parname, parent_name, var = RPR_GetSetMediaTrackInfo_String(track_id, 'P_NAME', 0, 0)
			instr_name = re.match(r'@\w+', str(parent_name))[0]
			dict_name = re.match(r'@(\w+)', str(parent_name))[1] + f'_{i+1}'

		num_items = RPR_GetTrackNumMediaItems(track_id)
		for j in range (num_items):
			item_id = RPR_GetTrackMediaItem(track_id, j)
			take_id = RPR_GetMediaItemTake(item_id, 0)
	
			if RPR_TakeIsMIDI(take_id):
				ret_val, ret_take, notecntOut, ret_cc, ret_sysex = RPR_MIDI_CountEvts(take_id, 0, 0, 0)
				for note_index in range(notecntOut):
					item = Item('midi', track_id, item_id, take_id, instr_name, dict_name)
					item.note_index = note_index
					items.append(get_midi_notes(item))
			else:
				source, source_type, size = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(take_id), '', BUFFER_SIZE)
				if not source_type:
					item = Item('text', track_id, item_id, take_id, instr_name, dict_name)
					items.append(get_empty_items(item))

	items = sorted(items, key=lambda item: item.start_pos)

	return items

def create_dirs():
	if os.path.exists(render_dir):
		shutil.rmtree(render_dir)

	os.mkdir(render_dir)

def get_cordelia_include_paths():
	paths = [CORDELIA_DIR + '/_core/setting.orc']
	with open(CORDELIA_DIR + '/_core/include.orc') as f:
		for line in f:
			path = line.strip().replace('"', '').replace('#include ', '')
			paths.append(path)
	return paths

def get_cordelia_instr_paths(instrs_used):
	paths = []
	for instr in instrs_used:
		path = CORDELIA_INSTR_json[instr]['path']
		paths.append(path)
	return paths

def get_cordelia_instr_clear_lines(instrs_used):
	lines = []

	master_line = [
			';---',
			'gSmouth[] init ginchnls',
			'indx	init 0',
			'until	indx == ginchnls do',
			'	gSmouth[indx] sprintf "mouth_%i", indx+1',
			'	isend	= 950 + (indx+1)/1000 + 1/10000',
			'	schedule isend, 0, -1, sprintf("mouth_%i", indx+1)',
			'	indx	+= 1',
			'od\n',
		]
	lines.append('\n'.join(master_line))
	for i, instr in enumerate(instrs_used):
		i += 1
		line = [
			';---',
			f'gS{instr}[] init ginchnls',
			'indx	init 0',
			'until	indx == ginchnls do',
			f'	gS{instr}[indx] sprintf "{instr}_%i", indx+1',
			f'	isend	= 950 + (indx+1)/1000 + {i+1}/10000',
			f'	schedule isend, 0, -1, sprintf("{instr}_%i", indx+1)',
			'	indx	+= 1',
			'od\n',
		]
		lines.append('\n'.join(line))
	return lines

def get_cordelia_gen_paths(gens_used):
	paths = []
	for gen in gens_used:
		if '$' in gen:
			gen = gen.split('$')[0]
		paths.append(CORDELIA_GEN_json[gen])
	return paths



path_dirs = set()
path_dirs.add(main_track_dir)

instrs_used = set()
gens_used = set()
track_names = set()
track_names.add(MAIN_TRACK_NAME)

items = get_all_items()

def get_csound_strings():

	instr_num_index = 0

	for item in items:

		path_dirs.add(tracks_dir + item.dict_name)
		track_names.add(item.dict_name)

		match item.type:
			case 'midi':
				removed_name = (item.instr_name).replace('@', '')

				replace_env = item.env.replace('.a', '$atk')

				if item.env[0] == '-':
					replace_env = replace_env.replace('-', '')
					prefix_env = '-gi' + replace_env
				else:
					prefix_env = 'gi' + replace_env

				if item.start_pos < 0:
					log('WARNING: some notes starts before 0, I just set them to 0!')
					log(f'in {item.dict_name} at {item.start_pos}, {item.type}')
					item.start_pos = 0

				csound_string = f'eva_midi "{removed_name}", {item.start_pos}, {item.dur}, {item.dyn}, {prefix_env}, {item.freq}'
				item.csound_string = csound_string
				instrs_used.add(removed_name)
				gens_used.add(replace_env)

			case 'text':
				removed_name = (item.instr_name).replace('@', '')
				
				if item.start_pos < 0:
					log('WARNING: some notes starts before 0, I just set them to 0!')
					log(f'in {item.dict_name} at {item.start_pos}, {item.type}')
					item.start_pos = 0

				if removed_name == 'cordelia':
					csound_string = f'\tinstr {int(instr_num_index + 300)}\n{item.text}\n\tendin\n'
					csound_string += f'schedule {int(instr_num_index + 300)}, {item.start_pos}, {item.end_pos}'
					item.csound_string = csound_string
					instr_num_index += 1
				else:
					score = extract_elements(item.text)
					score.insert(1, f'"{removed_name}"')
					score = ', '.join(score)
					csound_string = f'\tinstr {int(instr_num_index + 300)}\n{score}\n\tendin\n'
					csound_string += f'schedule {int(instr_num_index + 300)}, {item.start_pos}, {item.end_pos}'
					item.csound_string = csound_string
					instr_num_index += 1					


def write_strings():

	each_orc_path = []

	proj_len = RPR_GetProjectLength(0)

	includes = []
	includes.extend(get_cordelia_include_paths())
	includes.extend(get_cordelia_instr_paths(instrs_used))
	includes.extend(get_cordelia_gen_paths(gens_used))

	for each_track_name in track_names:
		lines = []
		score_lines = []

		for item in items:
			if each_track_name.startswith('cordelia'):
				lines.append(item.csound_string)
				
		if not each_track_name.startswith('cordelia'):
			
			lines.append(f'schedule "heart", 0, {proj_len}')
			lines.append('\tinstr end_score\nevent "e", 0, 0\nturnoff\n\tendin')
			lines.append(f'\tschedule "end_score", {proj_len}, 1')

			# create directory
			directory = os.path.join(render_dir, each_track_name)
			os.mkdir(directory)
			
			orc_file = os.path.join(directory, f'{project_name}-{each_track_name}.orc')

			with open(orc_file, 'wb') as main_orc:
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
				lines.extend(get_cordelia_instr_clear_lines(instrs_used))
		
				for item in items:
					if each_track_name == MAIN_TRACK_NAME:
						lines.append(item.csound_string)
						score_lines.append(item.csound_string)
					else:
						if item.dict_name == each_track_name:
							lines.append(item.csound_string)

				main_orc.write('\n\n\n;---SCORE---\n\n\n'.encode('utf-8'))
				main_orc.write('\n'.join(lines).encode('utf-8'))
			
				each_orc_path.append(orc_file)

	main_score_txt = os.path.join(directory, f'{project_name}-{each_track_name}-score.txt')
	with open(main_score_txt, 'w') as f:
		for line in score_lines:
			if line.startswith('eva_midi'):
				stripped_line = line.replace('eva_midi', '').lstrip().rstrip()
				f.write(f'{stripped_line}\n')



def execute_csound(chns, sr, ksmps):


	for each_track_name in track_names:
		if not each_track_name.startswith('cordelia'):
			directory = os.path.join(render_dir, each_track_name)
			orc_file = os.path.join(directory, f'{project_name}-{each_track_name}.orc')
			wav_file = os.path.join(directory, f'{project_name}-{each_track_name}.wav')
			log_file = os.path.join(directory, f'{project_name}-{each_track_name}.log')
			cmd_file = os.path.join(directory, f'_.command')

			command = f'csound -3 --nchnls={chns} -r {sr} --ksmps={ksmps} --orc {orc_file} -o {wav_file} &> {log_file}'

			with open(cmd_file, 'w') as f:
				f.write(command)
			
			subprocess.call(['chmod', '+x', cmd_file])

			# subprocess.call(['osascript', '-e', f'tell application "Terminal" to do script "{command}"'])
			#script = f'tell application "Terminal" to do script "{command} && exit"'

			script =	f'tell application "Terminal"\n' \
							f'set csound_script to "{command} && afplay -v 0.35 {SONVS_SUCCESS} && exit || echo ERROR $?"\n' \
							'do script csound_script\n' \
						f'end tell'
			
			subprocess.call(['osascript', '-e', script])

			""" # Wait for the command to finish
			p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
			stdout, stderr = p.communicate()

			# Check the exit status
			if p.returncode == 0:
				string = 'Command completed successfully!'
				log(string)
			else:
				string = f'Command failed with exit code {p.returncode}.'
				log(p.returncode)
				break """

retval, title, num_inputs, captions_csv, retvals_csv, retvals_csv_sz = RPR_GetUserInputs('Render with', 3, 'channels, sample rate, ksmps', '2,48,64', 512)

if retval:

	get_csound_strings()
	create_dirs()
	write_strings()

	values = retvals_csv.split(',')
	chns = values[0]
	sr = int(values[1]) * 1000
	ksmps = values[2]

	try:
		execute_csound(chns, sr, ksmps)
	except Exception as e:
		log(e)