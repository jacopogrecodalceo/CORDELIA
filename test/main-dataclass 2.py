from  dataclasses import dataclass, field

@dataclass
class Instrument:
	
	function: list

	name: str = None
	dur: str = None
	dyn: str = None
	env: str = None
	freq: list = None
	route: list = None
	space: str = None

	add_in: list = field(default_factory=list)
	add_out: list = field(default_factory=list)
	
	route: list = field(default_factory=list)

code = '''eu: 6, 8, 14, "heart", 1
re43@corpia@fonuo@aaron.flingj(9123, asd, .45).lofij(123, 3123-32*lgho/asdj)
gkbeats*$once(8, .25, 1, 0, 4)
accent(3, $pp)s
gieclassic$atk(5)
stept("2B", gilocrian, 3+pump(21, fillarray(2, 3, 4, 0))+pump(6, fillarray(7, 5/2, -1)))
stept("2B", gilocrian, 2+pump(22, fillarray(2, 3, 4, 0))+pump(12, fillarray(7, 5/2, -1)))*$once(.75, 1, 2)
stept("2B", gilocrian, pump(26, fillarray(2, 3, 4, 0))+pump(56, fillarray(7, 5/2, -1)))*$once(.25, 1, 2)'''

import re 
names = re.findall(r'@\w+', code)

result = []

lines = code.splitlines()

for name in names:
	
	function = [lines[0].split(':')[0], lines[0].split(':')[1].strip()]

	instrument = Instrument(function)
	
	instrument.dur = lines[2]
	instrument.dyn = lines[3]
	instrument.env = lines[4]
	instrument.freq = lines[5:]

	space = re.search(r'^(\w+?)@', lines[1])
	if space:
		instrument.space = space[1]
	
	for r in re.findall(r'\.(\w+\(.*?\))(?=(?:\.)|$)', lines[1]):
		route_name = re.search(r'^\w+', r)[0]
		route_params = re.search(r'^\w+\((.*)\)', r)[1]
		instrument.route.append([name, route_name, route_params])

	result.append(instrument)
import pprint
for each in result:
	pprint.pprint(each)