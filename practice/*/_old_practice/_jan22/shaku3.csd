	instr score

gkpulse	= 60

k1	= 1+(4*lfh(2))

$if eu(5, 8, 10, "heart") $then
	eva("shaku",
	gkbeats*once(fillarray(k1, 1)),
	accent(4),
	giclassic$atk(5),
	2)
endif

$if eu(3, 10, 8, "heart") $then
	eva("shaku",
	gkbeats*once(fillarray(k1, 1)),
	accent(4),
	giclassic$atk(5),
	8)
endif

$if hex("a8", 3.5, 1) $then
	eva("shaku",
	gkbeats*once(fillarray(1, k1)),
	accent(4),
	giclassic$atk(5),
	pump(12, fillarray(4, 4, 4, 4, 4, 4, 4, 4, 5, 3.75)))
endif

	endin
	start("score")

	instr route

getmeout("shaku")

	endin
	start("route")
