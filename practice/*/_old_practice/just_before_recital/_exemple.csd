	instr score

gkpulse	= 90

$if eu(8, 8, 32, "heart") $then
	eva("alonefr",
	gkbeats*.65,
	$mp,
	once(fillarray(gieclassic, giclassic)),
	step("3B", giwhole, pump(32, fillarray(1, 2, 7, 3, 5, 4, 6, 9)))*once(fillarray(.25, .5, 1)))
endif

	endin
	start("score")

	
	instr route

getmeout("alonefr")

	endin
	start("route")

