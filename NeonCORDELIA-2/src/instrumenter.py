class Instrument:
	def __init__(self):
		self.instrument_name = instrument_name

		if instrument_name == 'cordelia':
			self.csound_code = node.csound_code
		else:
			self.rhythm_name = node.rhythm_name
			self.rhythm_params = node.rhythm_params
			
			self.space = self.parse_space(node.space)
			self.dur = node.dur
			self.env = node.env
			self.freqs = self.parse_freq(node.freqs)

			self.dyn = self.parse_dyn(node.dyn, node.freqs)

			self.routes = self.parse_route(node.routes)