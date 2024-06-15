	instr score

gkpulse	= 90

$if eu(3, 8, 8, "heart") $then
	eva("alghed", 
	gkbeats*16,
	accent(5, $mp),
	gigrembo,
	fc("3B", gired, "5E", 1),
	fc("2B", gigrembo, "4E", 1))

endif

gkalghed_sonvs = 1


$if eu(3, 8, 8, "heart") $then
	eva("fim", 
	gkbeats*16,
	accent(5, $p),
	gigrembo,
	fc("3B", gired, "5E", 1),
	fc("2B", gigrembo, "4E", 1))
endif

	endin
	start("score")

	
	instr route

getmeout("alghed")
convj3("fim", "alghed")

	endin
	start("route")

