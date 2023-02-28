import re

import cordelia

class Instrument:
	def __init__(self, breed):
		self.breed = breed

class Parser():

	def __init__(self, unit):
		self.instruments = []

		self.unit = unit
		self.lines = unit.splitlines()
		
		if len(self.lines) == 1:
			self.scope = 'single_line'
		else:
			self.scope = 'multi_line'
			
		# Get all the names defined in the class
		names = dir(self)
		
		# Filter the names to only include method names
		method_names = [name for name in names if callable(getattr(self, name))]
		
		# Iterate over the method names and call each method
		for name in method_names:
			if not name.startswith('__') and not name == 'condition':
				getattr(self, name)()
				#result = getattr(self, name)()
				#print(f"{name} returned {result}")
		
	def condition(string, pattern):
		def decorator(func):
			def wrapper(self, *args, **kwargs):
				if self.scope == string and re.search(pattern, self.lines[0]):
					return func(self, *args, **kwargs)
			return wrapper
		return decorator

	#anything but @
	@condition('single_line', r'^[^@].*')
	def control(self):
		instrument = Instrument('control')
		instrument.csound_code = self.lines[0]
		self.instruments.append(instrument)
		
	@condition('multi_line', r'^eu:')
	def eu(self):

		names = re.findall(r'@(\w+)', self.lines[1])

		for name in names:

			instrument = Instrument('aural_instrument')
		
			instrument.rhythm_name = self.lines[0].split(':')[0]
			instrument.rhythm_p = self.lines[0].split(':')[1].strip()

			instrument.opcode = True

			space = re.search(r'^(.*?)@', self.lines[1])[1]
			if space:
				instrument.space = cordelia.conversion.space(space)
			else:
				instrument.space = '0'

			instrument.name = name
			instrument.dur = self.lines[2]
			instrument.dyn = self.lines[3]
			instrument.env = self.lines[4]
			
			instrument.freq = []

			for each_freq_line in self.lines[5:]:
				is_first_note = re.search(r'^(".*")', each_freq_line)
				if is_first_note:

					is_cpstun = re.search(r'^(".*"):', each_freq_line)
					if is_cpstun:
						intervals = each_freq_line.split(':')[1].lstrip().split(' ')
						intervals_togo = ', '.join(intervals)
						#for semitone, notation in CORDELIA_INTERVAL_json.items():
						#	intervals_togo = intervals_togo.replace(notation, semitone)
						#	print(intervals_togo)
						#freq_line = f'cpstun($once(1, 2), ntom({is_cpstun[1]})+once(fillarray({intervals_togo})), gktuning)'
						freq_line = f'cpstun_render(ntom({is_cpstun[1]})+once(fillarray({intervals_togo})), gktuning)'
						
						instrument.freq.append(freq_line)

					else:
						note = re.search(r'^(".*")', each_freq_line)[1]
						cycle = re.search(r'^"\w+"-(\d+)', each_freq_line)[1]
						limit = re.search(r'^"\w+"-\d+\.(\d+)', each_freq_line)[1]
						tab = re.search(r'^"\w+"-\d+\.\d+:(.*)', each_freq_line)[1].strip()

						#freq_line = f'cpstun($once(1, 2), ntom({note})+int(table:k((chnget:k("heart") * {cycle}) % 1, {tab}, 1)*{limit}), gktuning)'
						freq_line = f'cpstun_render(ntom({note})+int(tablekt:k((chnget:k("heart") * {cycle}) % 1, {tab}, 1)*{limit}), gktuning)'
						
						instrument.freq.append(freq_line)

				else:
					instrument.freq.append(each_freq_line)

			self.instruments.append(instrument)

			instrument = Instrument('aural_route')
			instrument.name = name

			route = re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|$)', self.lines[1])
			instrument.route = []
			if route:
				for r in route:
					route_name = re.search(r'^\w+', r)[0]
					route_p = [e.strip() for e in re.findall(r'(?:\([^)]*\)|[^,])+', re.search(r'^\w+\((.*)\)', r)[1])]
					instrument.route.append([route_name, route_p])
			else:
				instrument.route.append(['getmeout', '1'])

			self.instruments.append(instrument)

	@condition('single_line', r'^@.*')
	def seq(self):

		names = re.findall(r'@(\w+)', self.lines[0])

		for name in names:

			instrument = Instrument('control')

			space = re.search(r'^(.*?)@', self.lines[0])[1]
			if space:
				instrument.space = space
			else:
				instrument.space = '0'

			#instrument.dur = self.lines[2]
			params = self.lines[0].split(':')[1].strip()
			#instrument.env = self.lines[4]

			instrument.csound_code = f'{name}({params})'

			self.instruments.append(instrument)

			instrument = Instrument('aural_route')
			instrument.name = name

			route = re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|:)', self.lines[0])
			instrument.route = []
			if route:
				for r in route:
					route_name = re.search(r'^\w+', r)[0]
					route_p = [e.strip() for e in re.findall(r'(?:\([^)]*\)|[^,])+', re.search(r'^\w+\((.*)\)', r)[1])]
					instrument.route.append([route_name, route_p])
			else:
				instrument.route.append(['getmeout', '1'])

			self.instruments.append(instrument)
