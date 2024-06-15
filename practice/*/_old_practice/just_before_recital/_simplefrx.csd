	instr score

gkpulse	= 50

$if eu(3, 8, 12, "heart") $then
	eva("noij",
	gkbeats*8,
	$mp,
	giclassic,
	fc("0B", gired, "4D", 3))
endif

	endin
	start("score")

	
	instr route

getmeout("noij")

	endin
	start("route")

