import re

def space(string):
		
	if re.search(r'^[a-z]', string):
		if re.search(r'^r\d', string):
			string = re.sub(r'^r', 'oncegen(girot', string) + ')'
		elif re.search(r'^l\d', string):
			string = re.sub(r'^l', 'oncegen(giline', string) + ')'
		elif re.search(r'^e\d', string):
			string = re.sub(r'^e', 'oncegen(gieven', string) + ')'
		elif re.search(r'^o\d', string):
			string = re.sub(r'^o', 'oncegen(giodd', string) + ')'
		elif re.search(r'^a\d', string):
			string = re.sub(r'^a', 'oncegen(giarith', string) + ')'
		elif re.search(r'^d\d', string):
			string = re.sub(r'^d', 'oncegen(gidist', string) + ')'

	elif re.search(r'^-', string):
		if re.search(r'^-r\d', string):
			string = re.sub(r'^-r', 'oncegen(-girot', string) + ')'
		elif re.search(r'^-l\d', string):
			string = re.sub(r'^-l', 'oncegen(-giline', string) + ')'
		elif re.search(r'^-e\d', string):
			string = re.sub(r'^-e', 'oncegen(-gieven', string) + ')'
		elif re.search(r'^-o\d', string):
			string = re.sub(r'^-o', 'oncegen(-giodd', string) + ')'
		elif re.search(r'^-a\d', string):
			string = re.sub(r'^-a', 'oncegen(-giarith', string) + ')'
		elif re.search(r'^-d\d', string):
			string = re.sub(r'^-d', 'oncegen(-gidist', string) + ')'

	return string

