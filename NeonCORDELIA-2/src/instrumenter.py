class Instrument:
	def __init__(self, instrument_name):
		self.instrument_name = instrument_name

		self.freq = []
		self.rhythm = {}
		self.rounting = {}

	def print_attributes(self):
			attribute_names = dir(self)
			for name in attribute_names:
				if not name.startswith('__') and not callable(getattr(self, name)):
					print(f"{name}: {getattr(self, name)}")