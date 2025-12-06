from reaper_python import *

import re

from .string_func import *
from .config import MIDI_CORRECTION, BUFFER_SIZE

class Item:
	def __init__(self, type, track_id, item_id, take_id, track_num, note_index, parent_name):
		self.type = type
		self.track_id = track_id
		self.item_id = item_id
		self.take_id = take_id

		self.track_num = track_num
		self.note_index = note_index
		
		self.parent_name = parent_name
		
		self.instr_name = re.match(r'@\w+', str(parent_name))[0]
	
		if self.type == 'midi':
			self.get_midi_notes(self)
			self.csound_name = (self.instr_name).replace('@', '')

			replace_env = self.env.replace('.a', '$atk')

			if self.env[0] == '-':
				replace_env = replace_env.replace('-', '')
				self.prefix_env = '-gi' + replace_env
			else:
				self.prefix_env = 'gi' + replace_env

			if self.start_pos < 0:
				log('WARNING: some notes starts before 0, I just set them to 0!')
				self.start_pos = 0
		
		elif self.type == 'text':

			self.start_pos = RPR_GetMediaItemInfo_Value(self.item_id, 'D_POSITION')
			self.dur = RPR_GetMediaItemInfo_Value(self.item_id, 'D_LENGTH')
			self.end_pos = self.start_pos + self.dur

			self.csound_name = (self.instr_name).replace('@', '')

			retval, meditem, parname, raw_text, var = RPR_GetSetMediaItemInfo_String(self.item_id, 'P_NOTES', 0, 0)

			if raw_text.startswith('getmeout'):
				route = extract_csv(raw_text)
				route.insert(1, f'"{self.csound_name}"')
				self.route = ', '.join(route)


	def get_midi_notes(self):
		ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_velocity = RPR_MIDI_GetNote(self.take_id, self.note_index, 0, 0, 0, 0, 0, 0, 0)

		self.midi_pitch = note_pitch
		self.midi_chn = note_chn

		self.startppq_pos = startppqposOut
		self.start_pos = RPR_MIDI_GetProjTimeFromPPQPos(self.take_id, startppqposOut)
		self.end_pos = RPR_MIDI_GetProjTimeFromPPQPos(self.take_id, endppqposOut)

		self.dur = self.end_pos - self.start_pos
		self.dyn = note_velocity / MIDI_CORRECTION
		self.env = 'classic'
		
		freq = str(RPR_GetTrackMIDINoteNameEx(0, self.track_id, self.midi_pitch, self.midi_chn))
		self.freq = re.search(r'c.\s+(.*)', freq)[1]

		self.check_if_additional_text(self)
		self.get_midi_note_env_if_text(self)
	
	def check_if_additional_text(self):
		#retval, meditem, parname, text, var = RPR_GetSetMediaItemInfo_String(item.item_id, 'P_NOTES', 0, 0)
		retval, meditem, parname, track_name, var = RPR_GetSetMediaTrackInfo_String(self.track_id, 'P_NAME', 0, 0)
		text = track_name
		for line in extract_csv(text):
			if line.startswith('dur'):
				val = line.split('dur')[1]
				self.dur = eval(f'{self.dur}{val}')
			elif line.startswith('dyn'):
				val = line.split('dyn')[1]
				self.dyn = eval(f'{self.dyn}{val}')
			elif line.startswith('freq'):
				val = line.split('freq')[1]
				self.freq = eval(f'{self.freq}{val}')
			elif line.startswith('env.'):
				val = line.split('env.')[1].strip()
				self.env = val

	def get_midi_note_env_if_text(self):
		text_retval, take, textsyxevtidx, selectedOutOptional, mutedOutOptional, ppqposOutOptional, typeOutOptional, msgOptional, msgOptional_sz = RPR_MIDI_GetTextSysexEvt(self.take_id, 0, 0, 0, 0, 0, 0, BUFFER_SIZE)
		if text_retval and self.startppq_pos == ppqposOutOptional:
			# i don't know why, but i need to remove 2 character from the end of the text string
			if msgOptional.strip() != '':
				self.env = msgOptional[:-2:]
				#log(msgOptional)