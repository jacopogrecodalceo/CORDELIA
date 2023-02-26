	instr score

gkpulse	= 120-timeh(8)

$if	eu(5, 8, 16, "heart") $then
	e("dmitri",
	gkbeats*once(fillarray(4, 12, 0)),
	accent(3, $mf),
	-gikazan,
	step("1D", giquarter, pump(8, fillarray(1, 2, 7, 1, 3, 7)))*once(fillarray(1, 4, 2)),
	step("0D", gikumoi, pump(16, fillarray(1, 2, 7, 1, 3, 7)))*once(fillarray(1, 2, .5)))
endif

	endin
	start("score")

	instr route
flingj("dmitri", pump(8, fillarray(5, 25, 5, 125)), .95)
flingj("dmitri", pump(12, fillarray(5, 25, 5, 125))*.85, .95)

flingj3("qb", oscil:k(gkbeatms, gkbeatf/lfse(2, 12, gkbeatf/32), gispina), .95)
	endin
	start("route")
