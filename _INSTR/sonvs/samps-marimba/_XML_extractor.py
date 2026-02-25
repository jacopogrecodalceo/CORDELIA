from pprint import pprint
import re
import os
import json
from pathlib import Path
import ctcsound

PLAY = False
MIDI_NAME_JSON_path = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_releted/midi_name_freq.json'

with open(MIDI_NAME_JSON_path, 'r') as file:
	 MIDI_NAMEs = json.load(file)

SCRIPT_path = Path(__file__)
WAV_PATHs = [p for p in SCRIPT_path.parent.glob("*.wav")]

note_nums_extracted = []
for path in WAV_PATHs:
	#Mar_A8.wav
	note_name = path.stem.split('_')[-1]

	midi_num = MIDI_NAMEs['note_name'].index(note_name.replace('D#', 'Eb').replace('A#', 'Bb').replace('G#', 'Ab'))
	t = (path, int(midi_num-24))
	note_nums_extracted.append(t)
 
sorted_note_nums_extracted = sorted(note_nums_extracted, key=lambda x: x[1])
pprint(sorted_note_nums_extracted)

if_statements = []
for i in range(len(sorted_note_nums_extracted)-1):
	path, note_num = sorted_note_nums_extracted[i]
	next_path, next_note_num = sorted_note_nums_extracted[i + 1]
	print(f'Extracting note name and num in {path}')
 
 
	if i == 0:
		lo_note = 0
		hi_note = next_note_num-1
		root_note = note_num
		if_statement = f'''if inote <= {hi_note} && inote > {lo_note} then
	irootnote = {root_note}
	Sbase_name init "{path.stem + path.suffix}"'''
		if_statements.append(if_statement)

	elif i < len(sorted_note_nums_extracted)-2:
		lo_note = note_num-1
		hi_note = next_note_num-1
		root_note = note_num	
		if_statement = f'''elseif inote <= {hi_note} && inote > {lo_note} then
	irootnote = {root_note}
	Sbase_name init "{path.stem + path.suffix}"'''	

		if_statements.append(if_statement)
	elif i == len(sorted_note_nums_extracted)-2:
		lo_note = note_num-1
		hi_note = 127
		root_note = next_note_num
		if_statement = f'''elseif inote <= {hi_note} && inote > {lo_note} then
	irootnote = {root_note}
	Sbase_name init "{path.stem + path.suffix}"'''	

		if_statements.append(if_statement)

if_statements.append('endif')

for line in if_statements:
	 print(line)
 
if PLAY:
	FLAGs = [
		"-odac",
		"--sample-rate=48000",
		"--format=24bit",
		"--nchnls=2",
		"--ksmps=64",
		"--0dbfs=1",
		"--m-amps=1",
		"--m-range=1",
		"--m-warnings=0",
		"--m-dB=1",
		"--m-colours=1",
		"--m-benchmarks=0",
	]

	ORC = '''
	instr osc
aenv linseg 0, .005, 1, p3-.005*2, 1, .005, 0
aout oscil3 1/12, mtof:i(p4)
	outall aout*aenv
	endin
 
	instr reader
aenv linseg 0, .005, 1, p3-.005*2, 1, .005, 0
aouts[] diskin p4
	outall aouts[0]*aenv/2
	endin
 
'''
 
	SCO = []
	for index, (path, note_num) in enumerate(sorted_note_nums_extracted):
		dur = 1
		onset = 1
		cs_string_osc = f'i "osc" {(index)*onset} {dur} {note_num}'
		SCO.append(cs_string_osc)
		cs_string_reader = f'i "reader" {(index+1/2)*onset} {dur} "{path}"'
		SCO.append(cs_string_reader)
  
	cs = ctcsound.Csound()
	for f in FLAGs:
		cs.setOption(f)
	cs.compileOrc(ORC)
	cs.readScore('\n'.join(SCO))
	cs.start()
	cs.perform()
	cs.cleanup()
	cs.reset()
	del cs