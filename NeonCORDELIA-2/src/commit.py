from constants.var import cordelia_has

token_drop_types = [
	'INSTR',
	'GEN',
	'SCALA'
]

def commit_to_csound(tokens):
	parsed_tokens = []
	for token in tokens:
		if token.type in token_drop_types and token.value not in cordelia_has:
			# Put it into the list of used tokens
			cordelia_has.append(token.value)

			# Put in the result
			parsed_tokens.append(token)
			# send to compile list
		else:
			parsed_tokens.append(token)

	return parsed_tokens
