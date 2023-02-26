	instr score

gkpulse	= 95

$if	hex("80", 16) $then
	eva("qb",
	gkbeats,
	accent(3, $fff),
	giclassic,
	step("4A#", giminor3, once(fillarray(1, 5, 7, 3))),
	step("3A#", gimjnor, once(fillarray(2, 3, 5, 4))))	
endif

$if	eu(3, 16, 16, "heart", 2) $then
	eva("orphans2",
	gkbeats,
	accent(3, $fff),
	giclassic,
	step("4A#", gimjnor, pump(12, fillarray(1, 5, 7, 3))),
	step("4A#", giminor3, pump(16, fillarray(2, 3, 5, 4))))	
endif

katk	= 1 + lfa(3, gkbeatf/32)

$if	eu(3, 16, 16, "heart") $then
	eva("orphans",
	gkbeats*katk,
	accent(3, $ff),
	giclassic,
	step("3A#", gimjnor, pump(3, fillarray(1, 5, 7, 3))),
	step("2A#", giminor3, pump(4, fillarray(2, 3, 5, 4))))	
endif

	endin
	start("score")

	instr route

getmeout("qb")
getmeout("orphans2")
getmeout("orphans")	

	endin
	start("route")
