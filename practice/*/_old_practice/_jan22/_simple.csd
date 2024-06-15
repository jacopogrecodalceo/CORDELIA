	instr score

gkpulse	= 120

k1	= 1+(4*lfh(2))

$if hex("a9", 16) $then
	eva("six",
	gkbeats*once(fillarray(k1, 1)),
	accent(4),
	giclassic$atk(5),
	2)
endif

$if hex("a8", 16) $then
	eva("six",
	gkbeats*once(fillarray(1, k1)),
	accent(4),
	giclassic$atk(5),
	4)
endif

$if hex("128124", 48) $then
	eva("six",
	gkbeats,
	accent(4),
	gilikearev$atk(5),
	pump(8, fillarray(4, 8, 6, 2)))
endif

	endin
	start("score")

	instr route

getmeout("six")

	endin
	start("route")

