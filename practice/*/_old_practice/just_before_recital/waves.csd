	instr score

gkpulse	= 50

$if eu(3, 8, 4, "heart") $then
	eva("flou", "wutang",
	gkbeats*24,
	accent(5, $ppp),
	$once(giclassic, gidiocle),
	fc("2B", gired, "4D", 3)*.5,
	fc("2B", gired, "4D", 2),
	fc("2B", gigrembo, "4D", 3)*.5)
endif
	endin
	start("score")

	
	instr route

getmeout("flou")
getmeout("calinin")
getmeout("wutang")

	endin
	start("route")

