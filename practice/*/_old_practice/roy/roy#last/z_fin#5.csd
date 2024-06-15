	instr score

gkpulse	= 90

$if hex("af0000000027000", 16) $then
	eva("aaron",
	gkbeats*5,
	$mp,
	once(fillarray(gieclassic, giclassic)),
	step("4B", giwhole, 3+pump(32, fillarray(1, 2, 7, 3, 5, 4, 6, 9)))*$once(.5, 1),
	step("3B", giwhole, pump(32, fillarray(1, 2, 7, 3, 5, 4, 6, 9)))*$once(.5, 1))
endif

	endin
	start("score")

	
	instr route

getmeout("aaron")

	endin
	start("route")

