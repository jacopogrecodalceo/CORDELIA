	instr score

gkpulse	= 120

$if	hex("fa", 5) $then
	e("qb",
	gkbeats*once(fillarray(1, 2, 4)),
	accent(3, $f),
	gikazan,
	step("1D", giquarter, pump(8, fillarray(1, 2, 7, 1, 3, 7)))*once(fillarray(1, 4, 2)),
	step("3D", gikumoi, pump(16, fillarray(1, 2, 7, 1, 3, 7)))*once(fillarray(1, 2, .5)))
endif

	endin
	start("score")

	instr route
flingj("qb", samphold:k(oscil(gkbeatms, gkbeatf/lfse(2, 12, gkbeatf/32), gispina), metro(2)), .95)
	endin
	start("route")
