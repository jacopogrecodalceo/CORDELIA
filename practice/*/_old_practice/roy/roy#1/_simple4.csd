	instr score

gkpulse	= 90

$if eu(3, 8, 8, "heart") $then
	eva("flou", "careless", 
	gkbeats*16,
	accent(5, $mp),
	gigrembo,
	fc("3B", gired, "5E", 1),
	fc("2B", gigrembo, "4E", 1))
endif

$if eu(3, 8, 8, "heart", 2) $then
	eva("wutang", "flou", 
	gkbeats*3*$once(2, 1),
	accent(5, $mp)*$once(2/3, 1),
	gigrembo,
	fc("1B", gired, "5E", 2),
	fc("4B", gigrembo, "4E", 2))
endif

	endin
	start("score")

	
	instr route

getmeout("flou")
getmeout("careless")
getmeout("wutang")

	endin
	start("route")

