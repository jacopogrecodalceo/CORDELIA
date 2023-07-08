import json
from .const import *

#CORDELIA_DIR = path.abspath(path.join(__file__ , '../../../..'))
CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIA'

DEFAULT_SONVS_PATH = CORDELIA_DIR + '/_setting/_default-sonvs'
DEFAULT_SONVS_SAMP_PATH = CORDELIA_DIR + '/_setting/_default-sonvs_sampler'

CORDELIA_OUT_WAV = f'{CORDELIA_DIR}/_score/cor{DATE}.wav'
CORDELIA_OUT_RAW = f'{CORDELIA_DIR}/_score/cor{DATE}-raw.wav'
CORDELIA_OUT_ORC = f'{CORDELIA_DIR}/_score/cor{DATE}.orc'
CORDELIA_OUT_SCO = f'{CORDELIA_DIR}/_score/cor{DATE}.sco'
CORDELIA_OUT_LOG = f'{CORDELIA_DIR}/_score/cor{DATE}-csound.log'
CORDELIA_OUT_COR = f'{CORDELIA_DIR}/_score/cor{DATE}-cordelia.log'
CORDELIA_OUT_CSV = f'{CORDELIA_DIR}/_score/cor{DATE}.csv'
CORDELIA_OUT_MID = f'{CORDELIA_DIR}/_score/cor{DATE}.mid'
CORDELIA_OUT_CSCORE = f'{CORDELIA_DIR}/_score/cor{DATE}'


with open(CORDELIA_DIR + '/_setting' + '/module.json') as f:
	MODULE_json = json.load(f)

with open(CORDELIA_DIR + '/_setting' + '/macro', 'r') as f:
	init_macros = f.read().splitlines()
	for each in init_macros:
		if each:
			CORDELIA_MACROs.append(each)

with open(CORDELIA_DIR + '/_setting' + '/abbr.json') as f:
	ABBR_json = json.load(f)

with open(CORDELIA_DIR + '/_setting' + '/instr.json') as f:
	INSTR_json = json.load(f)

with open(CORDELIA_DIR + '/_setting' + '/scala.json') as f:
	SCALA_json = json.load(f)

with open(CORDELIA_DIR + '/_setting' + '/gen.json') as f:
	GEN_json = json.load(f)

with open(CORDELIA_DIR + '/_setting' + '/interval.json') as f:
	INTERVAL_json = json.load(f)
