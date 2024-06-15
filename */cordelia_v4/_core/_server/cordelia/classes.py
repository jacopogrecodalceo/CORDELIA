import re, pprint
from utils.udp import send_message_reaper
from utils.constants import CORDELIA_OSC_MESSAGE_LAST
import cordelia

class Instrument:
	def __init__(self, breed):
		self.breed = breed

class Route():
    def __init__(self, name):
        self.name = name

class Parser():

	def __init__(self, unit):

		self.instruments = []

		self.unit = unit
		self.lines = unit.splitlines()

		# SINGLE LINE
		if len(self.lines) == 1 and re.search(r'^cordelia_murmur', self.lines[0]):
			self.tape()
			return
		elif len(self.lines) == 1 and re.search(r'^@.*', self.lines[0]):
			self.seq()
			return
		elif len(self.lines) == 1 and re.search(r'^route.', self.lines[0]):
			self.route()
			return
		elif len(self.lines) == 1 and re.search(r'^[^@].*', self.lines[0]):
			self.control()
			return

		# MULTI LINE
		rhythm_regex = {'eu', 'hex', 'jex'}
		if len(self.lines) > 1 and self.lines[0].split(':', 1)[0] in rhythm_regex:
			self.rhythm_op()

	def control(self):
		instrument = Instrument('control')
		instrument.csound_code = self.lines[0]
		self.instruments.append(instrument)
		
	def rhythm_op(self):

		names = re.findall(r'@(\w+)', self.lines[1])
		routes = re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|$)', self.lines[1])

		for name in names:

			instrument = Instrument('aural_instrument')
			
			instrument.origin = 'eva'

			instrument.rhythm_name = self.lines[0].split(':')[0]
			instrument.rhythm_p = self.lines[0].split(':')[1].strip()

			space = re.search(r'^(.*?)@', self.lines[1])[1]
			if space:
				instrument.space = cordelia.conversion.space(space)
			else:
				instrument.space = '0'

			instrument.name = name
			instrument.dur = self.lines[2]
			instrument.dyn = self.lines[3]
			if routes:
				instrument.dyn += cordelia.if_multiple_route_then_reduce_amp(routes)
			instrument.dyn += cordelia.if_multiple_route_then_reduce_amp(self.lines[5:])

			instrument.env = self.lines[4]
			
			instrument.freq = []

			for each_freq_line in self.lines[5:]:
				is_first_note = re.search(r'^(".*")', each_freq_line)
				if is_first_note:

					is_cpstun = re.search(r'^(".*"):', each_freq_line)
					if is_cpstun:
						intervals = each_freq_line.split(':')[1].lstrip()
						#for semitone, notation in CORDELIA_INTERVAL_json.items():
						#	intervals_togo = intervals_togo.replace(notation, semitone)
						#	print(intervals_togo)
						#freq_line = f'cpstun($once(1, 2), ntom({is_cpstun[1]})+once(fillarray({intervals_togo})), gktuning)'
						freq_line = f'cpstun_render(ntom({is_cpstun[1]})+once({intervals}), gktuning)'
						print(freq_line)
						
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

			instrument.route_classes = []

			if routes:
				for r in routes:
					route_name = re.search(r'^\w+', r)[0]
					route_params_combined = re.search(r'^\w+\((.*)\)', r)[1]
					route_params = cordelia.extract_elements(route_params_combined)
					
					route = Route(route_name)
					route.values = route_params
					
					instrument.route_classes.append(route)
			else:
				route_name = 'getmeout'
				route_params = ['1']

				route = Route(route_name)
				route.values = route_params
				
				instrument.route_classes.append(route)		

			self.instruments.append(instrument)


	def tape(self):

		global CORDELIA_OSC_MESSAGE_LAST

		line = self.lines[0]

		if line != CORDELIA_OSC_MESSAGE_LAST:
			message_line = line.split(":", 1)[1]
			messages = message_line.split(",")
			for m in messages:
				m = 't/' + m.strip()
				print(m)
				send_message_reaper(m)
			CORDELIA_OSC_MESSAGE_LAST = line
			
		instrument = Instrument('control')
		instrument.csound_code = ';' + self.lines[0]
		self.instruments.append(instrument)

	def seq(self):

		names = re.findall(r'@(\w+)', self.lines[0])
		params_combined = self.lines[0].split(':')[1].strip()
		params = cordelia.extract_elements(params_combined)
		routes = re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|:)', self.lines[0])

		for name in names:

			instrument = Instrument('aural_instrument')

			instrument.origin = 'eva_sonvs'
		
			instrument.rhythm_name = 'changed2'
			instrument.rhythm_p = 'gkbeatn'

			space = re.search(r'^(.*?)@', self.lines[0])[1]
			if space:
				instrument.space = cordelia.conversion.space(space)
			else:
				instrument.space = '0'

			instrument.name = name

			fade = '.035'

			instrument.dur = f'gkbeats + {fade}'

			if len(params) > 1:
				instrument.dyn = params[1]
			else:
				instrument.dyn = '$f'

			if routes:
				instrument.dyn += cordelia.if_multiple_route_then_reduce_amp(routes)

			instrument.env = fade
			
			instrument.freq = [params[0]]

			self.instruments.append(instrument)

			instrument = Instrument('aural_route')
			instrument.name = name

			instrument.route_classes = []

			if routes:
				for r in routes:
					route_name = re.search(r'^\w+', r)[0]
					route_params_combined = re.search(r'^\w+\((.*)\)', r)[1]
					route_params = cordelia.extract_elements(route_params_combined)

					#route_params_with_empty_items = re.findall(r'[^,(]*(?:\([^)]*\)[^,(]*)*', route_params_combined)
					#route_params = list(filter(bool, route_params_with_empty_items))


					route = Route(route_name)
					route.values = route_params
					
					instrument.route_classes.append(route)
			else:
				route_name = 'getmeout'
				route_params = ['1']

				route = Route(route_name)
				route.values = route_params
				
				instrument.route_classes.append(route)		
			self.instruments.append(instrument)

	def route(self):

			self.lines[0] = self.lines[0].replace('route.', '')
			print(self.lines[0])
			names = re.findall(r'@(\w+)', self.lines[0])
			routes = re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|$)', self.lines[0])

			for name in names:

				instrument = Instrument('aural_route')
				instrument.name = name

				instrument.route_classes = []

				if routes:
					for r in routes:
						route_name = re.search(r'^\w+', r)[0]
						route_params_combined = re.search(r'^\w+\((.*)\)', r)[1]
						route_params = cordelia.extract_elements(route_params_combined)

						#route_params_with_empty_items = re.findall(r'[^,(]*(?:\([^)]*\)[^,(]*)*', route_params_combined)
						#route_params = list(filter(bool, route_params_with_empty_items))


						route = Route(route_name)
						route.values = route_params
						
						instrument.route_classes.append(route)
				else:
					route_name = 'getmeout'
					route_params = ['1']

					route = Route(route_name)
					route.values = route_params
					
					instrument.route_classes.append(route)	
				self.instruments.append(instrument)