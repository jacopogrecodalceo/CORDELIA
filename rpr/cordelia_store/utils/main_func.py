from reaper_python import *

import subprocess, os
from .string_func import *
from .item_class import *
from .path_func import get_cordelia_instr_paths, get_cordelia_gen_paths

from .config import BUFFER_SIZE
from .config import MAIN_TRACK_NAME, MAIN_RENDER_DIRECTORY, MAIN_PROJECT_NAME
from .config import CORDELIA_INCLUDE_PATHs
from .config import INSTR_JSON


def get_all_items():

	items = []
	
	num_tracks = RPR_CountTracks(0)
	for track_num in range(num_tracks):

		track_id = RPR_GetTrack(0, track_num)
		is_child = bool(RPR_GetMediaTrackInfo_Value(track_id, 'I_FOLDERDEPTH') <= 0)

		if not is_child:
			retval, meditem, parname, parent_name, var = RPR_GetSetMediaTrackInfo_String(track_id, 'P_NAME', 0, 0)

		num_items = RPR_GetTrackNumMediaItems(track_id)
		for j in range (num_items):
			item_id = RPR_GetTrackMediaItem(track_id, j)
			take_id = RPR_GetMediaItemTake(item_id, 0)
	
			if RPR_TakeIsMIDI(take_id):
				ret_val, ret_take, notecntOut, ret_cc, ret_sysex = RPR_MIDI_CountEvts(take_id, 0, 0, 0)
				for note_index in range(notecntOut):
					item = Item('midi', track_id, item_id, take_id, track_num, note_index, parent_name)
					items.append(item)
			else:
				source, source_type, size = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(take_id), '', BUFFER_SIZE)
				if not source_type:
					item = Item('text', track_id, item_id, take_id, track_num, 0, parent_name)
					items.append(item)

	items = sorted(items, key=lambda item: item.start_pos)

	return items

def create_csound_score(items):
	instr_num_index = 0

	for item in items:

		if item.type == 'midi':
			csound_string = f'eva_midi "{item.csound_name}", {item.start_pos}, {item.dur}, {item.dyn}, {item.prefix_env}, {item.freq}'
			item.csound_string = csound_string

		elif item.type == 'text':
			csound_string = f'\tinstr {int(instr_num_index + 300)}\n{item.route}\n\tendin\n'
			csound_string += f'schedule {int(instr_num_index + 300)}, {item.start_pos}, {item.end_pos}'
			item.csound_string = csound_string
			instr_num_index += 1

def get_instr_clear_lines(instrs):
	lines = []
	for i, instr in enumerate(instrs):
		line = [
			';---',
			f'gS{instr}[] init ginchnls',
			'indx	init 0',
			'until	indx == ginchnls do',
			f'	gS{instr}[indx] sprintf "{instr}_%i", indx+1',
			f'	isend	= 950 + (indx+1)/1000 + {i}/10000',
			f'	schedule isend, 0, -1, sprintf("{instr}_%i", indx+1)',
			'	indx	+= 1',
			'od\n',
		]
		lines.append('\n'.join(line))
	return lines


track_names = set()
track_names.add(MAIN_TRACK_NAME)



def write_strings(items):

	each_orc_path = []

	proj_len = RPR_GetProjectLength(0) + 1

	# include default cordelia files
	includes = []
	includes.extend(CORDELIA_INCLUDE_PATHs)

	instrs_used = list(set(item.name for item in items))
	gens_used = list(set(item.env for item in items))

	for instr in instrs_used:

		includes.extend(INSTR_JSON[instr]['path'])
		includes.extend(get_cordelia_gen_paths(gens_used))

		lines = []
		
		lines.append(f'schedule "heart", 0, {proj_len}')
		lines.append('\tinstr end_score\nevent "e", 0, .025\n\tendin')
		lines.append(f'\tschedule "end_score", {proj_len}, .025')

		# create directory
		directory = os.path.join(MAIN_RENDER_DIRECTORY, instr)
		os.mkdir(directory)
		
		orc_file = os.path.join(directory, f'{MAIN_PROJECT_NAME}-{item.dict_name}.orc')

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
			lines.extend(get_instr_clear_lines(instrs_used))
	

			if item.dict_name == each_track_name:
				lines.append(item.csound_string)

			main_orc.write('\n\n\n;---SCORE---\n\n\n'.encode('utf-8'))
			main_orc.write('\n'.join(lines).encode('utf-8'))
		
			each_orc_path.append(orc_file)
				


def execute_csound(chns, sr, ksmps):

	for each_track_name in track_names:
		directory = os.path.join(MAIN_RENDER_DIRECTORY, each_track_name)
		orc_file = os.path.join(directory, f'{MAIN_PROJECT_NAME}-{each_track_name}.orc')
		wav_file = os.path.join(directory, f'{MAIN_PROJECT_NAME}-{each_track_name}.wav')
		log_file = os.path.join(directory, f'{MAIN_PROJECT_NAME}-{each_track_name}.log')

		command = f'csound -3 --nchnls={chns} -r {sr} --ksmps={ksmps} --orc {orc_file} -o {wav_file} &> {log_file}'

		# subprocess.call(['osascript', '-e', f'tell application "Terminal" to do script "{command}"'])
		#script = f'tell application "Terminal" to do script "{command} && exit"'

		script =	f'tell application "Terminal"\n' \
						f'set myscript to "{command} && exit || echo ERROR $?"\n' \
						f'do script myscript\n' \
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
