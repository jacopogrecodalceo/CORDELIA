	instr score

gkpulse	= 120

k1	= 1+(4*lfh(2))

kch	pump 4, fillarray(1, 2, 1.5)

$if hex("a9a9a9a828", 16*kch) $then
	eva("shaku",
	gkbeats*once(fillarray(k1, 1)),
	accenth(4),
	giclassic$atk(5),
	pump(8, fillarray(2, random:k(2, 4), 2)))
endif

$if hex("a8a828a834", 16) $then
	eva("shaku",
	gkbeats*once(fillarray(1, k1)),
	accenth(4),
	giclassic$atk(5),
	4+oscil:k(4, pump(4, fillarray(30, 50, 90)), giclassic))
endif

	endin
	start("score")

	instr route

getmeout("shaku")

	endin
	start("route")
