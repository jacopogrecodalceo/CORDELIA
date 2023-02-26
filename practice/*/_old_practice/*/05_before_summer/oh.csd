	instr score

gkpulse	= 120

k1	pump 4, fillarray(0, -5)
k2	lfse 16, 48, gkbeatf/64

$if	eu(8, 16, 32, "heart") $then
	e("oh",
	gkbeats*once(fillarray(cunt(0, 32*4, 1), .5)),
	accent(4),
	gikazan,
	step("3E", gimjnor, pump(k2, fillarray(1, 2, 7, 1, 3, 7)), k1),
	step("4D", gimjnor, pump(k2, fillarray(1, 2, 7, 1, 3, 7)), k1))
endif

$if	eu(8, 16, 32, "heart") $then
	e("oh",
	gkbeats*once(fillarray(cunt(0, 32*4, 1), .5)),
	accent(4),
	gikazan,
	step("4E", gimjnor, pump(k2, fillarray(1, 2, 7, 1, 3, 7)), k1),
	step("2D", gimjnor, pump(k2, fillarray(1, 2, 7, 1, 3, 7)), k1))
endif

	endin
	start("score")

	instr route
getmeout("oh")
	endin
	start("route")
