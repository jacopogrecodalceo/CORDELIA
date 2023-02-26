	instr score

gkpulse	= 120 - timeh(8)



$if	eu(3, 16, 16, "heart") $then
	eva("bebois",
	gkbeats/2,
	accent(3, $mf),
	once(fillarray(giclassic, -gieclassic, gimirror)),
	step("4D", giwhole, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))),
	step("4C", giwhole, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif

gkgain = .5

	endin
	start("score")

	instr route
flingjs("repuck", oscili:k(.125, gkbeatf/lfse(12, 24, gkbeatf/12), gikazan), lfh(1))
flingj3("bebor", oscili:k(.125, gkbeatf/lfse(12, 24, gkbeatf/12), gikazan), lfh(1))

flingj3("bebois", oscili:k(gkbeatms*2, gkbeatf/lfse(12, 24, gkbeatf/12), gikazan), lfh(1)*.95)
moogj("bebois", 25+oscili:k(15$k, gkbeatf*lfse(4, 16, gkbeatf/16), giclassic), lfh(1))

moogj("wutang", 25+oscili:k(15$k, gkbeatf*lfse(4, 16, gkbeatf/16), giclassic), lfh(1))

	endin
	start("route")
