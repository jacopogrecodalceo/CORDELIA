	instr score

gkpulse	= 170 - timeh(8)

$if	eu(3, 8, 16, "heart") $then
	e("dmitri",
	gkbeats*once(fillarray(1, 2, .25, 4)),
	accent(3, $ff),
	once(fillarray(giclassic, -gieclassic, gikazan)),
	step("3D", gikumoi, pump(16, fillarray(1, 2, 7, 1, 3, 7)))*once(fillarray(1, 2, .5)),
	step("0D", gikumoi, pump(24, fillarray(1, 2, 7, 1, 3, 7)))*once(fillarray(1, 4, 2)))
endif
$if	eu(3, 8, 16, "heart", 2) $then
	e("dmitri",
	gkbeats*once(fillarray(1, 2, .25, 4)),
	accent(3, $ff),
	once(fillarray(giclassic, -gieclassic, gikazan)),
	step("3D", gikumoi, pump(16, fillarray(1, 2, 7, 1, 3, 7)))*once(fillarray(1, 2, .5)))
endif
$if	eu(3, 8, 16, "heart", 2) $then
	e("fim",
	gkbeats*once(fillarray(1, 2, .25, .25)),
	accent(3, $fff),
	once(fillarray(-giclassic, gieclassic, -gikazan)),
	step("1D", giquarter, pump(8, fillarray(1, 2, 7, 1, 3, 7)))*once(fillarray(1, 4, 2)),
	step("1D", gikumoi, pump(16, fillarray(1, 2, 7, 1, 3, 7)))*once(fillarray(1, 2, .5)))
endif
	endin
	start("score")

	instr route
flingj("dmitri", oscil:k(25, gkbeatf/lfse(2, 24, gkbeatf/12), gispina), .95)
flingj("fim", oscil:k(15, gkbeatf/lfse(2, 4, gkbeatf/8), gispina), .75)
flingj3("dmitri", oscil:k(95, gkbeatf/lfse(2, 12, gkbeatf/4), gispina), .95)

	endin
	start("route")
