	instr score

kless	goi .95, 95, .05

gkpulse	= 120 - (phasor:k(.5)>kless ? 100 : 0)

$if	eu(8, 16, 32, "heart") $then
	e("puck",
	gkbeats*(8*accent(8)),
	accent(4),
	gieclassic$atk(5),
	step("4D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif

$if	eu(3, 16, 8, "heart") $then
	e("puck",
	gkbeats*(16*accent(8)),
	accent(4),
	once(fillarray(giclassic, -gieclassic, gimirror)),
	step("3D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif

$if	eu(3, 8, 4, "heart") $then
	e("puck",
	gkbeats*(24*accent(8)),
	accent(4),
	once(fillarray(-giclassic$atk(5), -gieclassic, -gikazan)),
	step("1D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif
	endin
	start("score")

	instr route
flingue3("puck", oscil:k(25, gkbeatf/12, gikazan))
moog("puck", 25+oscil:k(15$k, gkbeatf*lfse(.25, 8, gkbeatf/16), giclassic))
	endin
	start("route")
