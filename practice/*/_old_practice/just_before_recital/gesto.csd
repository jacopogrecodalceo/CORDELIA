	instr score

gkpulse	= 90

$if eu(3, 8, 32, "heart") $then
	eva("fim",
	gkbeats*4,
	$f,
	once(fillarray(gieclassic, giclassic)),
	step("4E", gikal, pump(32, fillarray(1, 2, 7, 3, 5, 4, 6, 9)))*once(fillarray(.5, .5, 1)))
endif

gesto1(4, $f)

	endin
	start("score")

	
	instr route

envfrj("gesto1", "fim", .05, 2)
getmeout("gesto1")
	endin
	start("route")

