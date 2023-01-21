
code = '''
eu: 6, 8, 3, "heart"
	@orphans3
	gkbeats*$once(8, .25, 1)
	accent(3, $fff)
	gieclassic$atk(5)
	stept("4B", gilocrian, 5+pump(21, fillarray(2, 3, 4, 0))+pump(6, fillarray(7, 5/2, -1)))*$once(.75, 1, 2)
'''

custom = Custom(code)
print(custom)