	instr score

gkpulse	= 105

ninfa(pump(16, fillarray(4, 8, 12, 16, 24, 4, 8)), $mp)

	endin
	start("score")

	instr route
getmeout("ninfa")
getmeout("amor")
getmeout("fim")
flingue("bee", lfse(0, 5, gkbeatf/64), .75, lfa(.5, gkbeatf/128))
	endin
	start("route")
