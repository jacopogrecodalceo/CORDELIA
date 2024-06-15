import json, re

sub_json_path = '/Users/j/Documents/PROJECTs/CORDELIAv4/_list/subs.json'

#open json
with open(sub_json_path) as f:
	sub_json = json.load(f)


module = '''eu: "10", 2
	+Snote = g4#
	;comment
	r4@orphans4@maybe.flingj(123, lfh(2)).getmeout(2.2, 123, asd())
	gkbeats*32
	;dioporco
	pp
	classic
	cpstun(random:k(1, 2), once(), ntom(Snote)+2, givitry)
	cpstun(random:k(1, 2), ntom(Snote)+2, givitry)
	cpstun(random:k(1, 2), ntom(Snote)+2, givitry)
	cpstun(random:k(1, 2), ntom(Snote)+2, givitry)
'''

for cat in sub_json:
	match cat:
		case 'macro':
			for name in sub_json[cat]:
				module = re.sub(rf'(\W){name}(\W)', rf'\1${name}\2', module, re.MULTILINE)
		case 'givar':
			for name in sub_json[cat]:
				module = re.sub(rf'(\W){name}(\W)', rf'\1gi{name}\2', module, re.MULTILINE)
		case 'gkvar':
			for name in sub_json[cat]:
				module = re.sub(rf'(\W){name}(\W)', rf'\1gk{name}\2', module, re.MULTILINE)
		case 'note':
			for name in sub_json[cat]:
				module = re.sub(rf'(\W){name}(\d)', rf'\1\2{name.upper()}', module, re.MULTILINE)						
		
print(module)
