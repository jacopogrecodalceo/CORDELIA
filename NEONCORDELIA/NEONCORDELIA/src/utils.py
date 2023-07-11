import re

def extract_comma_params(string):
	elements = []
	paren_count = 0
	start = 0
	for i, c in enumerate(string):
		if c == '(':
			paren_count += 1
		elif c == ')':
			paren_count -= 1
		elif c == ',' and paren_count == 0:
			elements.append(string[start:i])
			start = i + 1
	elements.append(string[start:])
	return [elem.strip() for elem in elements if elem]

def extract_node(code):
	nodes = re.findall(r'^(.(?:\n|.)*?)\n$', code, flags=re.MULTILINE)
	return nodes
