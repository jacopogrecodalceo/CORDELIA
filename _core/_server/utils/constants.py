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

CORDELIA_DATE = datetime.today().strftime('%y%m%d-%H%M')

CORDELIA_OUT_WAV = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}.wav'
CORDELIA_OUT_ORC = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}.orc'
CORDELIA_OUT_SCO = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}.sco'
CORDELIA_OUT_CSV = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}.csv'
CORDELIA_OUT_MID = f'{CORDELIA_DIR}/_score/cor{CORDELIA_DATE}.mid'

SCALA_HASPLAYED = []
GEN_HASPLAYED = []
INSTR_HASPLAYED = []

CORDELIA_NOTEs = ['c', 'c#', 'db', 'd', 'd#', 'eb', 'e', 'f', 'f#', 'gb', 'g', 'g#', 'ab', 'a', 'a#', 'bb', 'b']

CORDELIA_MACROs = []
with open(CORDELIA_DIR + '/_list' + '/macro', 'r') as f:
	init_macros = f.read().splitlines()
	for each in init_macros:
		if each:
			CORDELIA_MACROs.append(each)

with open(CORDELIA_DIR + '/_list' + '/abbr.json') as f:
	CORDELIA_ABBR_json = json.load(f)

with open(CORDELIA_DIR + '/_list' + '/instr.json') as f:
	CORDELIA_INSTR_json = json.load(f)

with open(CORDELIA_DIR + '/_list' + '/scala.json') as f:
	CORDELIA_SCALA_json = json.load(f)

with open(CORDELIA_DIR + '/_list' + '/gen.json') as f:
	CORDELIA_GEN_json = json.load(f)

with open(CORDELIA_DIR + '/_list' + '/interval.json') as f:
	CORDELIA_INTERVAL_json = json.load(f)

CORDELIA_COMPILE = []

class bcolors:
    WARNING = '\033[91m''\033[1m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

LINE_SEP = '≿━━━━━━━━━━━━━━━━━━━━༺❀༻━━━━━━━━━━━━━━━━━━━━≾\n'
