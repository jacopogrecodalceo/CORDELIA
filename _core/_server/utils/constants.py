import os.path as path
import json
from datetime import datetime 

CORDELIA_DIR = path.abspath(path.join(__file__ , '../../../..'))

CORDELIA_PORTs = {
	10015: 'BRAIN',
	10000: 'CSOUND',
	10025: 'REAPER',
}

CORDELIA_SOCKETs = []

CORDELIA_FOUT_MEMORIES = True

CORDELIA_DATE = datetime.today().strftime('%y%m%d-%H%M')

DEFAULT_SONVS_PATH = CORDELIA_DIR + '/_setting/_default-sonvs'
DEFAULT_SONVS_SAMP_PATH = CORDELIA_DIR + '/_setting/_default-sonvs_sampler'
DEFAULT_SONVS_SYNC_PATH = CORDELIA_DIR + '/_setting/_default-sonvs_sync'
DEFAULT_SONVS_LPC_PATH = CORDELIA_DIR + '/_setting/_default-sonvs_lpc'
DEFAULT_SONVS_CONV_PATH = CORDELIA_DIR + '/_setting/_default-sonvs_conv'

CORDELIA_CURRENT_DIR = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}'
CORDELIA_OUT_WAV = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}/cor{CORDELIA_DATE}.wav'
CORDELIA_OUT_RAW = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}/cor{CORDELIA_DATE}-raw.wav'
CORDELIA_OUT_ORC = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}/cor{CORDELIA_DATE}.orc'
CORDELIA_OUT_SCO = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}/cor{CORDELIA_DATE}.sco'
CORDELIA_OUT_LOG = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}/cor{CORDELIA_DATE}-csound.log'
CORDELIA_OUT_COR = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}/cor{CORDELIA_DATE}-cordelia.log'
CORDELIA_OUT_CSV = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}/cor{CORDELIA_DATE}.csv'
CORDELIA_OUT_MID = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}/cor{CORDELIA_DATE}.mid'
CORDELIA_OUT_CSCORE = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}/cor{CORDELIA_DATE}'

SCALA_HASPLAYED = []
GEN_HASPLAYED = []
INSTR_HASPLAYED = ['mouth']

CORDELIA_OSC_MESSAGE_LAST = ''

CORDELIA_NOTEs = ['c', 'c#', 'db', 'd', 'd#', 'eb', 'e', 'f', 'f#', 'gb', 'g', 'g#', 'ab', 'a', 'a#', 'bb', 'b']

CORDELIA_MACROs = []
with open(CORDELIA_DIR + '/_setting' + '/macro', 'r') as f:
	init_macros = f.read().splitlines()
	for each in init_macros:
		if each:
			CORDELIA_MACROs.append(each)

with open(CORDELIA_DIR + '/_setting' + '/abbr.json') as f:
	CORDELIA_ABBR_json = json.load(f)

with open(CORDELIA_DIR + '/_setting' + '/instr.json') as f:
	CORDELIA_INSTR_json = json.load(f)

with open(CORDELIA_DIR + '/_setting' + '/scala.json') as f:
	CORDELIA_SCALA_json = json.load(f)

with open(CORDELIA_DIR + '/_setting' + '/gen.json') as f:
	CORDELIA_GEN_json = json.load(f)

with open(CORDELIA_DIR + '/_setting' + '/interval.json') as f:
	CORDELIA_INTERVAL_json = json.load(f)

with open(CORDELIA_DIR + '/_setting' + '/module.json') as f:
	CORDELIA_MODULE_json = json.load(f)

try:
	with open('/Volumes/petit_elements_di_j/_sonvs_reseau/soundfont/sf.json') as f:
		CORDELIA_SF_json = json.load(f)
except Exception:
	CORDELIA_SF_json = ''


CORDELIA_COMPILE_FIRST = []
CORDELIA_COMPILE = []

class bcolors:
    WARNING = '\033[91m''\033[1m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

LINE_SEP = '≿━━━━━━━━━━━━━━━━━━━━༺❀༻━━━━━━━━━━━━━━━━━━━━≾\n'
