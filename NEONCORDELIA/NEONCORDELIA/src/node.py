import re

import src.utils as utils
import config.const as const

def single_line(condition):
	def decorator(func):
		def wrapper(self):
			if len(self.lines) == 1 and condition(self):
				return func(self)
		return wrapper
	return decorator

def multi_line(condition):
	def decorator(func):
		def wrapper(self):
			if len(self.lines) > 1 and condition(self):
				return func(self)
		return wrapper
	return decorator

class Node:

	def __init__(self, node):

		# init values
		self.instrument_names = ['cordelia']
		self.routes = ['getmeout(1)']
		self.space = '0'
		self.lines = [line.rstrip().lstrip() for line in node.splitlines()]

		funcs = [func for func in dir(self) if callable(getattr(self, func)) and not func.startswith("__")]

		for func_name in funcs:
			func = getattr(self, func_name)
			val = func()
			if val:
				return
	
	@single_line(lambda self: re.search(r'^[^@].*', self.lines[0]))
	def plain_csound(self):
		self.csound_code = self.lines[0]

		return True

	@single_line(lambda self: re.search(r'^@.*', self.lines[0]))
	def sequenza(self):

		main_line = self.lines[0].split(':', 1)
		main_params = utils.extract_comma_params(main_line[1])

		self.rhythm_name = 'changed2'
		self.rhythm_params = 'gkbeatn'

		self.instrument_names = re.findall(r'@(\w+)', main_line[0])

		routes_match = re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|$)', main_line[0])
		if routes_match:
			self.routes = routes_match

		space_match = re.match(r'^(.*?)@', main_line[0])
		if space_match.group(1):
			self.space = space_match.group(1)

		fade = .025
		self.dur = f'gkbeats + {fade}'
		self.dyn = main_params[1]
		self.env = 'classic'
		self.freqs = list(main_params[0])

		return True
	
	@multi_line(lambda self: self.lines[0].split(':', 1)[0] in const.RHYTHM_RE)
	def opcode_rhythm(self):

		main_line = self.lines[0].split(':', 1)

		self.rhythm_name = main_line[0]
		self.rhythm_params = utils.extract_comma_params(main_line[1])

		self.instrument_names = re.findall(r'@(\w+)', self.lines[1])

		routes_match = re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|$)', self.lines[1])
		if routes_match:
			self.routes = routes_match

		space_match = re.match(r'^(.*?)@', self.lines[1])
		if space_match.group(1):
			self.space = space_match.group(1)

		self.dur = self.lines[2]
		self.dyn = self.lines[3]
		self.env = self.lines[4]
		self.freqs = list(self.lines[5:])

		return True

