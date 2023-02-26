	instr score

gkpulse	= 105

ninfa(4, $mf)
gkninfa_time = 2
gkninfa_dur	= .25

ninfa(8, $mf)

ninfa(12, $mp)
ninfa(16, $p)

	endin
	start("score")

	instr route
getmeout("ninfa")
getmeout("amor")
getmeout("fim")
flingue("bee", lfse(0, 5, gkbeatf/64), .75, lfa(.5, gkbeatf/128))
	endin
	start("route")
