	instr score

gkpulse	= 50

$if eu(3, 8, 8, "heart") $then
	eva("flou", "careless",
	gkbeats*8,
	accent(3, $ff),
	giclassic,
	fc("2B", gired, "4D", 3),
	fc("2B", gigrembo, "4D", 3))
endif

$if eu(3, 8, 4, "heart") $then
	eva("wutang",
	gkbeats*24,
	accent(5, $pp),
	giclassic,
	fc("2B", gired, "4D", 2)*1.5,
	fc("2B", gigrembo, "4D", 2)*1.5)
endif
	endin
	start("score")

	
	instr route

getmeout("flou")
getmeout("careless")
getmeout("wutang")

	endin
	start("route")

