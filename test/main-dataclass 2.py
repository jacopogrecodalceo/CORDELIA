
class Instrument():
	opcode: str()
	space: str()
	name: list()
	dur: str()
	dyn: str()
	env: str()
	freq: list()
	add_in: list()
	add_out: list()
	route: list()

code = '''
gktuning pump 4, fillarray(gi12_22h, gipyth12, gi11_10ET)

eu: 6, 8, 14, "heart", 1
	@corpia.moogj(portk(stept("4B", gilocrian, pump(32, fillarray(2, 3, 4, 1))), .05), .5, 3)
	gkbeats*$once(8, .25, 1, 0, 4)
	accent(3, $pp)
	gieclassic$atk(5)
	stept("2B", gilocrian, 3+pump(21, fillarray(2, 3, 4, 0))+pump(6, fillarray(7, 5/2, -1)))
	stept("2B", gilocrian, 2+pump(22, fillarray(2, 3, 4, 0))+pump(12, fillarray(7, 5/2, -1)))*$once(.75, 1, 2)
	stept("2B", gilocrian, pump(26, fillarray(2, 3, 4, 0))+pump(56, fillarray(7, 5/2, -1)))*$once(.25, 1, 2)
'''

instrument = Instrument()
instrument.name = 'sijfo'
print(instrument.name)