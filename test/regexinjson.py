import re
import json

with open('/Users/j/Documents/PROJECTs/CORDELIAv4/test/subs.json', 'r') as f:
	subs = json.load(f)

data = '''

eu: 6, 8, 3, "heart"
	@orphans3
	gkbeats*$once(8, .25, 1)
	accent(3, fff)
	gieclassicatk(5)
	stept(ff, gilocrian, 5+pump(21, fillarray(2, 3, 4, 0))+pump(6, fillarray(7, 5/2, -1)))*$once(.75, 1, 2)

	'''

for each in subs['macro']['pattern']:
	for name in subs['macro']['name']:
		pattern = each[0].replace('__repl__', name)
		repl = each[1].replace('__repl__', name)
		print(repl)
		data = re.sub(pattern, repl, data, flags=re.MULTILINE - re.UNICODE)
		#data = re.sub(rf'(\W){name}(\W)', rf'\1"\2{name.upper()}"', data, flags=re.MULTILINE)

print(data)
