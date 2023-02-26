	instr score

gkpulse	= 120 - timeh(8)

$if	eu(2, 16, expseg:k(4, 85, 32, 25, 16), "heart") $then
	e("repuck",
	gkbeats*random(4, 12),
	accent(4, $mf),
	-once(fillarray(giclassic, gieclassic)),
	step("2A", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))),
	step("1D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif

$if	eu(3, 16, expseg:k(2, 55, 8, 35, 2), "heart") $then
	e("fim",
	gkbeats*12,
	accent(4, $p),
	once(fillarray(giclassic, -gieclassic, gimirror)),
	step("3A", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))),
	step("4D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif

$if	eu(3, 8, expseg:k(2, 55, 8, 25, 2), "heart") $then
	e("fim",
	gkbeats*12,
	accent(4, $mf),
	once(fillarray(-giclassic, -gieclassic, -gikazan)),
	step("0D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif
	endin
	start("score")

	instr route
powerranger("repuck", lfse(.05, 1, gkbeatf/8))
flingue3("fim", oscil:k(.125, gkbeatf/lfse(12, 24, gkbeatf/12), gikazan), hlowa(1, gkbeatf)*comeforme(55))
moog("fim", 25+oscil:k(15$k, gkbeatf*lfse(4, 16, gkbeatf/16), giclassic), hlowa(1, gkbeatf, .25)*comeforme(45))
	endin
	start("route")
