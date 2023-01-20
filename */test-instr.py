from config import cordelia_path
import json

instr_json_path = '/Users/j/Documents/PROJECTs/CORDELIAv4/instr.json'

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    FAIL = '\033[91m'
    WARNING = '\033[91m''\033[1m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

#open json
with open(instr_json_path) as f:
    instr_json = json.load(f)

#add a negative boolean for each session

for params in instr_json.values():
    params.update({'alive': False})
 

live_name = 'puck'

if live_name in instr_json.keys():
    #if not alive (not played) - play and alive is true
    if not instr_json[live_name]['alive']:
        #send instrument to csound
        #---
        #update params
        instr_json[live_name]['alive'] = True
else:
    print(f'{bcolors.WARNING}WARNING{bcolors.ENDC}: the instrument named {bcolors.WARNING}{live_name}{bcolors.ENDC} has a problem!')


