import json
import os.path as path
from .path_func import get_reaper_project_info

BUFFER_SIZE = 512 * 512
MIDI_CORRECTION = 1024

# NAMES CONFIG
MAIN_TRACK_NAME = '_main'

MAIN_PROJECT_DIRECTORY, MAIN_PROJECT_NAME = get_reaper_project_info()
MAIN_RENDER_DIRECTORY_NAME = f'{MAIN_PROJECT_NAME}-cordelia_render'
MAIN_RENDER_DIRECTORY = path.join(MAIN_PROJECT_NAME, MAIN_RENDER_DIRECTORY_NAME)

SONVS_SUCCESS = '/Users/j/Documents/script/OOT_Get_Heart.wav'
SONVS_ERROR = '/Users/j/Documents/script/OOT_Navi_WatchOut1.wav'

exluded_track_names = [MAIN_TRACK_NAME, 'cordelia']

# CORDELIA CONFIG

CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIA'

instr_json_path = path.join(CORDELIA_DIR, '_setting', 'instr.json')
with open(instr_json_path) as f:
	INSTR_JSON = json.load(f)

gen_json_path = path.join(CORDELIA_DIR, '_setting', 'instr.json')
with open(gen_json_path) as f:
	GEN_JSON = json.load(f)

def get_cordelia_include_paths():
	paths = [CORDELIA_DIR + '/_core/setting.orc']
	with open(CORDELIA_DIR + '/_core/include.orc') as f:
		for line in f:
			path = line.strip().replace('"', '').replace('#include ', '')
			paths.append(path)
	return paths

CORDELIA_INCLUDE_PATHs = get_cordelia_include_paths()