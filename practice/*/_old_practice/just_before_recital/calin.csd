	instr score

gkpulse	= 50

$if eu(3, 8, 4, "heart") $then
	eva("calin",
	gkbeats*24,
	accent(5, $fff),
	giclassic,
	fc("2B", gired, "4D", 2)*1.5,
	fc("2B", gigrembo, "4D", 2)*1.5)
endif
	endin
	start("score")

	
	instr route

getmeout("flou")
getmeout("calin")
getmeout("wutang")

	endin
	start("route")

