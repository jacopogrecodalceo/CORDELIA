	instr score

gkpulse	= 30

kndx line 0, 90, 1/64

$if eujo(5, 8, 8) $then
	eva("skij",
	gkbeats,
	accent(3),
	once(fillarray(gieclassic, giclassic)),
	step("3B", giwhole, pump(32, fillarray(1, 2, 7, 3, 5, 4, 6, 9)))*once(fillarray(.25, .5, 1)))
endif

$if eujo(5, 8, 8, kndx) $then
	eva("skij",
	gkbeats,
	accent(3),
	once(fillarray(gieclassic, giclassic)),
	step("4B", giwhole, pump(32, fillarray(1, 2, 7, 3, 5, 4, 6, 9)))*once(fillarray(.25, .5, 1)))
endif

	endin
	start("score")

	
	instr route

kfreq = step("0B", giwhole, pump(32, fillarray(1, 2, 7, 3, 5, 4, 6, 9)))
ringj3("skij", kfreq, .5)

	endin
	start("route")

