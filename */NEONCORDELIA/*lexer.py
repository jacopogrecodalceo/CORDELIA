import re
import json

# Define token types using regular expressions
def load_token_patterns(file_path):
	with open(file_path, 'r') as config_file:
		return json.load(config_file)

# Load token patterns from JSON configuration
token_patterns = load_token_patterns('./config/token_patterns.json')

# Token class to store token information
class Token:
	def __init__(self, type, value):
		self.type = type
		self.value = value

def tokenize(code):
	tokens = []
	position = 0  # Initialize the starting position

	while position < len(code):
		match = None
		for token in token_patterns:
			regex = re.compile(token['pattern'])
			match = regex.match(code, position)  # Start matching from the current position
			if match:
				token_value = match.group(0)
				if token['type'] != 'SPACE':
					tokens.append(Token(token['type'], token_value))
				position = match.end()  # Update the position to after the matched token
				break
		
		if not match:
			position += 1
	
	return tokens
