from datetime import datetime 

CSOUND_COMPILE = []


UDP_PORTs = {
	10015: 'CORDELIA',
	10000: 'CSOUND',
	10025: 'REAPER',
}

UDP_SOCKETs = []
UDP_SIZE = 4096



DATE = datetime.today().strftime('%y%m%d-%H%M')
RHYTHM_RE = {'eu', 'hex', 'jex'}

# INIT CONSTs
SOCKETs = []
SCALA_HASPLAYED = []
GEN_HASPLAYED = []
INSTR_HASPLAYED = []
CORDELIA_MACROs = []
CORDELIA_COMPILE_FIRST = []
CORDELIA_COMPILE = []

# FIXED CONSTs
NOTE_NAMEs = ['c', 'c#', 'db', 'd', 'd#', 'eb', 'e', 'f', 'f#', 'gb', 'g', 'g#', 'ab', 'a', 'a#', 'bb', 'b']

class bcolors:
    WARNING = '\033[91m''\033[1m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

LINE_SEP = '≿━━━━━━━━━━━━━━━━━━━━༺❀༻━━━━━━━━━━━━━━━━━━━━≾\n'
