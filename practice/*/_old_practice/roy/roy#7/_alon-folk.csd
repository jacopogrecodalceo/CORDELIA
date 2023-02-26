	instr score

gkpulse	= 90

$if eu(4, 8, 32, "heart") $then
	eva("alonefr",
	gkbeats,
	$mp,
	once(fillarray(gieclassic, giclassic)),
	step("0B", giwhole, pump(32, fillarray(1, 2, 7, 3, 5, 4, 6, 9)))*once(fillarray(.25, 13, 1, 9, 3, 4)))
endif

	endin
	start("score")

	
	instr route

getmeout("alonefr", comeforme(15))

	endin
	start("route")

