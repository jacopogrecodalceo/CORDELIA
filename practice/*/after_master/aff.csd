	instr score

gkpulse	= 130

$if eu(5, 8, 16, "heart") $then
	eva("simki", 
	gkbeats*$once(4, 1, 1, .5),
	accent(3, $f),
	giclassic,
	step("4D", giminor, 2+pump(16, fillarray(1, 2, 7))))
endif

$if eu(5, 8, 16, "heart", 2) $then
	eva("simki", 
	gkbeats*$once(4, .25, 1),
	accent(3, $f),
	gieclassic,
	step("4D", giminor, pump(16, fillarray(1, 2, 7))))
endif

$if eu(5, 8, 12, "heart") $then
	eva("simki", 
	gkbeats*$once(.15, .25, 4),
	accent(3, $f),
	gieclassic,
	step("4D", giminor, pump(16, fillarray(1, 2, 7)))*$once(2, 1, .25))
endif

	endin
	start("score")

	
	instr route

flingj("simki", gkbeatms)

	endin
	start("route")

