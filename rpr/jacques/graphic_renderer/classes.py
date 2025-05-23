import math
import random
from typing import List
import os
import abjad
import io
import cairosvg
from matplotlib import colors
import shoebot

import draw

COLORs = [
    'black', 'red', 'green', 'blue',
    'yellow', 'cyan', 'magenta', 'orange', 'purple',
    'pink', 'brown', 'gray', 'olive', 'navy',
    'teal', 'lime', 'indigo', 'gold', 'salmon',
    'coral', 'turquoise', 'aqua', 'beige', 'lavender'
]

class PolylineParser:
	def __init__(self, dimensions, margin, background_color='white'):
		self.width, self.height = dimensions
		self.margin = margin
		self.usable_width = self.width - 2 * self.margin
		self.usable_height = self.height - 2 * self.margin
		self.background_color = background_color

	def _convert_point(self, index, point):
		x, y = point

		# SCALE
		x = x * self.usable_width
		y = (index * self.basic_vertical_dist) + (y * self.basic_vertical_dist)

		# ADD MARGIN
		x = self.margin + x
		y = self.margin + y
		return (x, y)

	def from_node_events(self, node_events_raw):
		"""
		Collect a list of onset and freq for each staff
		onsets = [
			(onset1, freq1),
			(onset2, freq2),
			..
		]
		"""
		# sort nodes by onset
		node_events = [
			sorted(events, key=lambda event: event.onset)
			for events in node_events_raw
		]

		self.params_by_staff = []
		for index_staff, events in enumerate(node_events):
			params = [(event.onset, event.freq) for event in events]
			self.params_by_staff.insert(index_staff, params)

	@staticmethod
	def _parse_csound_score(csound_score_path) -> List:

		def is_float(p: str) -> bool:
			try:
				float(p)
				return True
			except ValueError:
				return False

		score = []
		with open(csound_score_path, 'r') as f:
			lines = f.readlines()
			all_i_lines = [line for line in lines if line.startswith('i')]
			while lines:
				line = lines.pop(0)
				if line.startswith('staff index'):
					staff = []
					while lines:
						peek = lines[0]
						if peek.startswith('staff index'):
							break
						line = lines.pop(0)
						if line.startswith('i'):
							staff.append(line)
					score.append(staff)
		assert sum(len(staff) for staff in score) == len(all_i_lines), 'Missing some score lines'

		for staff in score:
			for line_index, line in enumerate(staff):
				parts = line.strip().split()
				staff[line_index] = [
					float(p) if is_float(p) else p
					for p in parts
				]

		return score
	
	def from_csound_score(self, csound_score_path):
		if not os.path.exists(csound_score_path):
			raise FileNotFoundError('No score found')

		score = self._parse_csound_score(csound_score_path)
		self.params_by_staff = []
		for index_staff, line in enumerate(score):
			params = []
			for p in line:
				onset = p[2]
				freq = p[6]
				params.append((onset, freq))
			self.params_by_staff.insert(index_staff, params)

	@staticmethod
	def norm_x(x_param, max_param):
		x = x_param / max_param
		return x
	
	@staticmethod
	def norm_y(y_param, max_param):
		y = math.log2(max_param - y_param + 1) / math.log2(max_param + 1)
		return y
	
	@staticmethod
	def convert_freq_in_pitch(freq):
		pitch = abjad.NamedPitch.from_hertz(freq).name
		return pitch

	def _make_main_staff(self, b):
		max_onset = max([onset for params in self.params_by_staff for onset, _ in params])
		max_freq = max([freq for params in self.params_by_staff for _, freq in params])

		for i, params in enumerate(self.params_by_staff):
			points = []
			for onset, freq in params:
				x = self.norm_x(onset, max_onset)
				y = self.norm_y(freq, max_freq)
				point = (x, y)
				point = self._convert_point(self.global_staff_index, point)
				points.append(point)

			draw.linear(b, points, alpha=.75, color=self.colors[i])
			draw.bezier(b, points, alpha=.75, color=self.colors[i])

			name_points = (self.name_points[0], self.name_points[1]+(self.basic_vertical_dist*self.global_staff_index))
			draw.staff_name(b, name_points, f'main_staff')

		self.global_staff_index += 1

	def _make_separate_staves(self, b):
		max_onset = max([onset for staff in self.params_by_staff for onset, _ in staff])

		for index_staff, params in enumerate(self.params_by_staff):
			max_freq = max([freq for _, freq in params])
			points = []
			pitches = []
			for onset, freq in params:
				x = self.norm_x(onset, max_onset)
				y = self.norm_y(freq, max_freq)
				point = (x, y)

				pitch = self.convert_freq_in_pitch(freq)

				point = self._convert_point(self.global_staff_index, point)
				points.append(point)
				pitches.append(pitch)

			draw.linear(b, points, color=self.colors[index_staff])
			draw.bezier(b, points, color=self.colors[index_staff])
			draw.points(b, points, color='black')
			draw.pitches(b, points, pitches, offset_y=-35)

			name_points = (self.name_points[0], self.name_points[1]+(self.basic_vertical_dist*self.global_staff_index))
			draw.staff_name(b, name_points, f'staff_{index_staff+1}')
			self.global_staff_index += 1

	def export_all(self, output_path):
		
		# SVG buffer
		svg_data = io.BytesIO()

		b = shoebot.create_bot(buff=svg_data, format='svg')
		b.size(self.width, self.height)
		b.background(*colors.to_rgba(self.background_color))
		
		self.global_staff_index = 0
		self.staves_number = len(self.params_by_staff) + 1
		self.basic_vertical_dist = self.usable_height / self.staves_number
		self.name_points = (self.usable_width / 9, self.margin)

		self.colors = random.sample(COLORs, len(self.params_by_staff))

		self._make_main_staff(b)

		self._make_separate_staves(b)

		assert self.global_staff_index == self.staves_number, f'{self.global_staff_index =}, {self.staves_number =}'

		b.finish()
		svg_data.seek(0)
		with open(f'{output_path}.svg', 'wb') as f:
			f.write(svg_data.getvalue())
			
		svg_output = svg_data.read()
		cairosvg.svg2png(bytestring=svg_output, write_to=f'{output_path}.png')

	def export_score(self, output_path):
	
		# SVG buffer
		svg_data = io.BytesIO()

		b = shoebot.create_bot(buff=svg_data, format='svg')
		b.size(self.width, self.height)
		b.background(*colors.to_rgba(self.background_color))
		
		self.global_staff_index = 0
		self.staves_number = 1
		self.basic_vertical_dist = self.usable_height / self.staves_number
		self.name_points = (self.usable_width / 9, self.margin)

		self.colors = random.sample(COLORs, len(self.params_by_staff))

		self._make_main_staff(b)

		assert self.global_staff_index == self.staves_number, f'{self.global_staff_index =}, {self.staves_number =}'

		b.finish()
		svg_data.seek(0)
		svg_output = svg_data.read()
		
		with open(f'{output_path}.svg', 'wb') as f:
			f.write(svg_data.getvalue())
			
		svg_output = svg_data.read()
		cairosvg.svg2png(bytestring=svg_output, write_to=f'{output_path}.png')

	def export_parts(self, output_path):
	
		# SVG buffer
		svg_data = io.BytesIO()

		b = shoebot.create_bot(buff=svg_data, format='svg')
		b.size(self.width, self.height)
		b.background(*colors.to_rgba(self.background_color))
		
		self.global_staff_index = 0
		self.staves_number = len(self.params_by_staff)
		self.basic_vertical_dist = self.usable_height / self.staves_number
		self.name_points = (self.usable_width / 9, self.margin)

		self.colors = random.sample(COLORs, len(self.params_by_staff))

		self._make_separate_staves(b)

		assert self.global_staff_index == self.staves_number, f'{self.global_staff_index =}, {self.staves_number =}'

		b.finish()
		svg_data.seek(0)
		svg_output = svg_data.read()
		
		with open(f'{output_path}.svg', 'wb') as f:
			f.write(svg_data.getvalue())
			
		svg_output = svg_data.read()
		cairosvg.svg2png(bytestring=svg_output, write_to=f'{output_path}.png')


if __name__ == '__main__':
	import json
	import sys
	from pathlib import Path

	def read_json_input(json_path):
		with open(json_path, 'r') as f:
			return json.load(f)

	def display_note_table(params_by_staff):
		note_table = []
		for index_staff, params in enumerate(params_by_staff):
			for onset, freq in params:
				pitch = PolylineParser.convert_freq_in_pitch(freq)
				note_table.append({
					'staff': index_staff + 1,
					'onset': round(onset, 3),
					'freq': round(freq, 3),
					'pitch': pitch
				})
		return note_table

	if len(sys.argv) != 2:
		print("Usage: python your_script.py <input.json>")
		sys.exit(1)

	INPUT_PATH = Path(sys.argv[1])
	parsed = read_json_input(str(INPUT_PATH))

	# assuming parsed is a list of lists with dicts having 'onset' and 'freq'
	class DummyEvent:
		def __init__(self, onset, freq):
			self.onset = float(onset)
			self.freq = float(freq)

	node_events_raw = {}
	for e in parsed:
		if e['staff_name'] not in node_events_raw:
			node_events_raw[e['staff_name']] = []
		node_events_raw[e['staff_name']].append(DummyEvent(e['onset'], e['freq']))

	node_events = []
	for k, staff_events in node_events_raw.items():
		node_events.append(staff_events)

	width = 297 * 10
	height = 210 * 10
	margin = 75

	polyline = PolylineParser((width, height), margin)

	polyline.from_node_events(node_events)
	polyline.export_all(os.path.join(INPUT_PATH.parent, f'{INPUT_PATH.stem}-all-from_nodes.png'))


