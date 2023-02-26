	instr score

gkpulse	= 90

$if eu(3, 8, 4, "heart") $then
	eva("leo",
	gkbeats,
	$mp,
	once(fillarray(gieclassic, giclassic)),
	step("1B", giwhole, pump(8, fillarray(1, 2, 7, 3, 5, 4, 6, 9))))
endif

	endin
	start("score")

	
	instr route

getmeout("leo")

	endin
	start("route")

