from utils import *
from reaper_python import *

instrs_used = set()
gens_used = set()
track_names = set()
track_names.add(MAIN_TRACK_NAME)

default_ch = '2'
defalut_sr = '48'
default_ksmps = '64'

retval, title, num_inputs, captions_csv, retvals_csv, retvals_csv_sz = RPR_GetUserInputs('Render with', 3, 'channels, sample rate, ksmps', f'{default_ch},{defalut_sr},{default_ksmps}', 512)

if retval:


	items = get_all_items()

	add_csound_score(items)

	create_main_dir(MAIN_RENDER_DIRECTORY)
	write_strings(items)

	values = retvals_csv.split(',')
	chns = values[0]
	sr = int(values[1]) * 1000
	ksmps = values[2]

	try:
		execute_csound(chns, sr, ksmps)
	except Exception as e:
		log(e)