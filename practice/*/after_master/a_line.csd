	instr score

gkpulse	= 90

$if eu(3, 8, 32, "heart") $then
	eva(oncegen(girot3), "repuck", 
	gkbeats*4,
	accent(5, $mp),
	$once(gired, gigrembo)$atk(5),
	fc("4B", gired, "6E", 1)*$once(.25, 1, .5, 1, 1),
	fc("4B", gigrembo, "4E", 1)*$once(1, .25, 1, 2, 1))
endif

	endin
	start("score")

	
	instr route

getmeout("repuck")

	endin
	start("route")

