	instr score

gkpulse	= 120

k1	= 1+(2*lfh(2))

$if hex("a9a9a9a0", 8) $then
	eva("mario1",
	gkbeats*pump(24, fillarray(1, .25, 1, .35)),
	accent(4, $fff),
	giclassic,
	4)
endif

$if hex("a9a0", 8, 1) $then
	eva("mario1",
	gkbeats/pump(12, fillarray(1, .25, 1, .35)),
	accent(4, $ff),
	gilikearev,
	8)
endif

amen(8, $mp)

$if eu(8, 12, 16, "heart") $then
	eva("wutang",
	gkbeats/4,
	accent(3),
	gieclassic,
	step("3Bb", gipentamaj, pump(24, fillarray(1, random:k(1, 8), 3, random:k(1, 8)))))
endif

	endin
	start("score")

	instr route

ringhj3("mario1", pump(1, fillarray(1, 2, 4)), .35, gihsquare)
ringhj("amen", pump(8, fillarray(1, .5, 1, .65)), 0, gihsquare)
distj2("wutang", 1)
k35h("mario1", pump(32, fillarray(2, 4, 6, 8, 1, .5))$k, .35)
k35h("mario2", pump(8, fillarray(2, 4, 6, 8, 1, .5))$k, .35)

	endin
	start("route")

