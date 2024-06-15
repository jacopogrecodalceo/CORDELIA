	instr score

if gkroy1 == 1 then
	eva("wutang", "flou",
	gkbeats,
	accent(3, $mf),
	gikazanr,
	fc("1B", gired, "4D", 6),
	fc("2B", gigrembo, "5D", 6))

	gkroy1 = 0

endif

if gkroy2 == 1 then
	eva("mhon",
	gkbeats*$once(1, 1, 3, 1, 1, 12),
	accent(5, $f),
	gilikearev$atk(5),
	step("3F", gipentamin, 2+$once(1, 3, 5)),
	step("4F", gipentamin, $once(1, 3, 5, 7)))

	gkroy2 = 0
endif

	endin
	start("score")

	
	instr route

flingj3("wutang", lfh(9), .85)
flingj("mhon", 500, .75)
getmeout("wutang")
getmeout("flou")
getmeout("mhon2")

	endin
	start("route")

