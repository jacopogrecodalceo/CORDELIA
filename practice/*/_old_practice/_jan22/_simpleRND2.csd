	instr score

gkpulse	= 120

kdur	= 1+(12*lfh:k(2))

$if hex("8", 32) $then
	eva("six",
	gkbeats*int(random:k(0, kdur)),
	accenth(4, $fff),
	gilikearev$atk(5),
	pump(8, fillarray(4, 8, 6, 2)))
endif

$if hex("817fba", 12) $then
	eva("shaku",
	gkbeats*int(random:k(0, kdur)),
	accenth(4),
	gilikearev$atk(5),
	pump(8, fillarray(4, 8, 0, 2)))
endif

	endin
	start("score")

	instr route

ringj7("shaku", .5, .1, gieclassicr)
ringj7("six", 3, .15, gieclassic)
ringj7("six", 1, .15, gieclassic)
getmeout("amen", fadeaway(25))
	endin
	start("route")
