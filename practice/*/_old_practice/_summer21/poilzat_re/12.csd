	instr score

gkpulse	= 95-lfse(-25, 25, gkbeatf)

k1	pump 4, fillarray(4, 0, -4, -5)

kee	pump 4, fillarray(32, 8, 32, 32, 16)

$if	eu(7, 16, kee, "heart") $then
	e("repuck", "burd",
	gkbeats/8,
	accent(4, $fff),
	giclassic,
	step("5F#", giminor3, once(fillarray(3, 7, 5, 3, 2, 5, 3))+k1),
	step("5F#", giminor3, once(fillarray(2, 3, 5, 3))+k1))	
endif

$if	eu(4, 16, kee+2, "heart", 2) $then
	e("ohoh", "puck",
	gkbeats/4,
	accent(4, $fff),
	gilikearev,
	step("0F#", giminor3, once(fillarray(2, 5, 3))+k1),
	step("6F#", giminor3, once(fillarray(3, 7, 5, 3, 2, 5, 3))+k1),
	step("1F#", giminor3, once(fillarray(2, 3, 5, 3))+k1))	
endif
	endin
	start("score")

	instr route
folj("ohoh", "repuck", 5, 5, .5)

folj("burd", "repuck", 5, 5)
getmeout("repuck")
getmeout("puck")
flingj3("puck", oscil:k(gkbeats, gkbeatf/96, gikazan), .95)

	endin
	start("route")
