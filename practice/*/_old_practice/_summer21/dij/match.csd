	instr score

gkpulse	= 150 - timeh(8)

$if	eu(5, 8, 16, "heart") $then
	e("dmitri",
	gkbeats,
	accent(3, $f),
	once(fillarray(giclassic, gieclassic, -gikazan)),
	step("1D", gikumoi, pump(48, fillarray(1, 2, 7, 1, 3, 7)))*once(fillarray(1, 2, 3)))
endif
	endin
	start("score")

	instr route
flingj("dmitri", oscil:k(25, gkbeatf/lfse(2, 24, gkbeatf/12), gispina), .95)
	endin
	start("route")
