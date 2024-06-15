	instr score

gkpulse	= 70

k1	go 0, 95, 120

$when(hex("a9", 3))
	eva(once(fillarray("aaron", "wutang", "fuji")),
	gkbeats*12,
	accent(9, $mf, $pp),
	gieclassic,
	step("3E", gikal, random:k(1, 12))-k1)
endif

	endin
	start("score")

	instr route

frj("aaron", lfh(4), .95, 12, gisine, .75)
getmeout("aaron", .75)

frj("wutang", lfh(3), .95, 12, gisine, .75)
getmeout("wutang", .75)

frj("fuji", lfh(2), .95, 12, gisine, .75)
getmeout("fuji", .75)
	endin
	start("route")

