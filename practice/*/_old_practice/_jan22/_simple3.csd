	instr score

gkpulse	= 120

k1	= 1+(4*lfh(2))

$if hex("a9", 16) $then
	eva("six2",
	gkbeats*once(fillarray(k1, 1)),
	accent(4),
	giclassic$atk(5),
	2)
endif

$if hex("a8", 16) $then
	eva("six2",
	gkbeats*once(fillarray(1, k1)),
	accent(4),
	giclassic$atk(5),
	4)
endif

$if hex("128124", 48) $then
	eva("six2",
	gkbeats*2,
	accent(4),
	gilikearev$atk(5),
	pump(8, fillarray(4, 8, 6, 2)))
endif

	endin
	start("score")

	instr route

ringhj5("six2", 4, .75, gilikearev)
ringhj5("six2", .5, .25, gieclassicr)
ringhj5("six2", pump(16, fillarray(3, .25)), .95, gieclassicr, lfh(4))

	endin
	start("route")
