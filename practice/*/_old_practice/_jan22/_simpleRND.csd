	instr score

gkpulse	= 120

kdur	= 1+(12*lfh:k(2))
kch	int lfh(1)*ginchnls

$if hex("8", 64) $then
	eva(oncegen(girot2)+kch, "six",
	gkbeats*int(random:k(0, kdur)),
	accenth(4, $f),
	gilikearev$atk(5),
	pump(8, fillarray(4, 8, 6, 2)/4))
endif

$if hex("8", 32) $then
	eva(oncegen(girot6), "tension",
	gkbeats,
	accenth(4, $ff),
	giclassic,
	pump(8, fillarray(4, 8, 6, 2)/4))
endif

$if hex("817fba", 4) $then
	eva("shaku",
	gkbeats*int(random:k(0, kdur)),
	accenth(4, $mp),
	gilikearev,
	pump(8, fillarray(4, 8, 0, 2)))
endif

	endin
	start("score")

	instr route

getmeout("tension")
ringj7("shaku", .5, .95, gieclassicr)
ringj7("six", 3, .5, gieclassic)
ringj7("six", 1, .5, gieclassic)

	endin
	start("route")
