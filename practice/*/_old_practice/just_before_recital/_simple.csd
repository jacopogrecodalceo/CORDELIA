	instr score

gkpulse	= 90

$if eu(3, 8, 12, "heart") $then
	eva("noij",
	gkbeats*$once(1, 1, 8),
	$mp,
	$once(gidiocle, giclassic),
	fc("2B", gidiocle, "4D", 3))
endif

	endin
	start("score")

	
	instr route

getmeout("noij")

	endin
	start("route")

