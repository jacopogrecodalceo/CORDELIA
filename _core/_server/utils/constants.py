import os.path as path
import json
from datetime import datetime 

CORDELIA_DIR = path.abspath(path.join(__file__ , '../../../..'))

CORDELIA_PORTs = {
	10015: 'CORDELIA_from_BRAIN',
	10000: 'CSOUND_from_CSOUND',
	10025: 'CORDELIA_from_REAPER',
	10005: 'CSOUND_from_REAPER'
	}

CORDELIA_SOCKETs = []

CORDELIA_DATE = datetime.today().strftime('%y%m%d-%H%M')

CORDELIA_OUT_WAV = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}.wav'
CORDELIA_OUT_ORC = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}.orc'
CORDELIA_OUT_ORC = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}.mid'

SCALA_HASPLAYED = []
GEN_HASPLAYED = []
INSTR_HASPLAYED = []

with open(CORDELIA_DIR + '/_list' + '/replace.json') as f:
	CORDELIA_REPLACE_json = json.load(f)

with open(CORDELIA_DIR + '/_list' + '/instr.json') as f:
	CORDELIA_INSTR_json = json.load(f)

with open(CORDELIA_DIR + '/_list' + '/scala.json') as f:
	CORDELIA_SCALA_json = json.load(f)

with open(CORDELIA_DIR + '/_list' + '/gen.json') as f:
	CORDELIA_GEN_json = json.load(f)

class bcolors:
    WARNING = '\033[91m''\033[1m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

LINE_SEP = ';≿━━━━━━━━━━━━━━━━━━━━༺❀༻━━━━━━━━━━━━━━━━━━━━≾\n'
