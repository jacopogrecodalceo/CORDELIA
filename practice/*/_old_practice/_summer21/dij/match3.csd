	instr score

gkpulse	= 120

$if	eu(3, 8, 16, "heart") $then
	e("qb",
	gkbeats*once(fillarray(1, 4, .25, .25)),
	accent(3, $ff),
	gikazan$atk(5),
	step("1D", giquarter, pump(8, fillarray(1, 2, 7, 1, 3, 7)))*once(fillarray(1, 4, 2)),
	step("0D", gikumoi, pump(16, fillarray(1, 2, 7, 1, 3, 7)))*once(fillarray(1, 2, .5)))
endif

	endin
	start("score")

	instr route
flingj("dmitri", oscil:k(25, gkbeatf/lfse(16, 24, gkbeatf/12), gispina), .95)
flingj("fim", oscil:k(15, gkbeatf/lfse(2, 4, gkbeatf/8), gispina), .75)
flingj3("qb", oscil:k(gkbeatms, gkbeatf/lfse(2, 12, gkbeatf/32), gispina), .95)
	endin
	start("route")
