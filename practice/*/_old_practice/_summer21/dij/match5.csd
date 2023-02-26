	instr score

gkpulse	= 120-timeh(8)

gkamen_dur = 1
amen(4, $p)

	endin
	start("score")

	instr route
flingj("ninfa", pump(8, fillarray(5, 25, 5, 125)), .95)
flingj("dance", pump(3, fillarray(5, 25, 5, 125))*.35, .95)
flingj("amen", pump(32, fillarray(5, 25, 5, 125)), .85)
	endin
	start("route")
