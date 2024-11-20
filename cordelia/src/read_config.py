import yaml

# Define the file path for the configuration file
CONFIG_FILE_PATH = '/Users/j/Documents/PROJECTs/CORDELIA/cordelia/config.yaml'

class Main_config:
	def __init__(self):
		"""Initialize with the path to the configuration file and load it."""
		config = self.load_config(CONFIG_FILE_PATH)
		self.channels = config['channels']
		sources = ['audio', 'control']
		self.nchnls = sum([self.channels[s]['count'] for s in sources])
		for source in sources:
			self._generate_csound_map_array(source)
			setattr(self, f'csound_{source}_array_count', self.channels[source]['count'])

	def load_config(self, file_path):
		"""Load the YAML configuration file."""
		try:
			with open(file_path, 'r') as f:
				return yaml.safe_load(f)
		except FileNotFoundError:
			raise ValueError(f"Configuration file not found: {file_path}")
		except yaml.YAMLError as e:
			raise ValueError(f"Error parsing YAML configuration: {e}")

	def _generate_csound_map_array(self, source):
		"""Generate the csound string array for a given source (audio/control)."""
		csound_global_var = f'giCORDELIA_NCHNLs_{source.upper()}_MAP'
		setattr(self, f'csound_{source}_array_var', csound_global_var)

		csound_global_var += '[]'
		# Generate the array by mapping the channel mappings
		array = self.channels[source]['mapping'].values()
		csound_array = [csound_global_var, 'fillarray', ', '.join(map(str, array))]

		setattr(self, f'csound_{source}_array_line', ' '.join(csound_array))
