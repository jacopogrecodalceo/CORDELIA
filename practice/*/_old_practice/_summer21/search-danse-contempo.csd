	instr score

gkpulse	= 120-timeh(8)

contempo(16, $mf)
search(16, $mf)

	endin
	start("score")

	instr route
flingj("contempo", pump(6, gkbeatms-fillarray(5, 25, 5, 125)), .95)
flingj("contempo", pump(12, fillarray(5, 25, 5, 125))*.85, .95)

flingj3("search", oscil:k(gkbeatms, gkbeatf/lfse(2, 12, gkbeatf/32), gispina), .95)
	endin
	start("route")
