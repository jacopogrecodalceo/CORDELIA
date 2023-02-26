	instr score

gkpulse	= 60

k1	= 1+(4*lfh(2))

$if hex("a9", 16) $then
	eva("shaku",
	gkbeats*once(fillarray(k1, 1)),
	accent(4),
	giclassic$atk(5),
	2)
endif

$if hex("a8", 16) $then
	eva("shaku",
	gkbeats*once(fillarray(1, k1)),
	accent(4),
	giclassic$atk(5),
	4)
endif

	endin
	start("score")

	instr route

getmeout("shaku")

	endin
	start("route")
