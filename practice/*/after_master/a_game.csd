	instr score

gkpulse	= 90

$if eu(3, 8, 32, "heart") $then
	eva(oncegen(girot3), "betweenmore", 
	gkbeats*4,
	accent(5, $p),
	$once(gired, gigrembo)$atk(5),
	step("3B", giminor3, pump(2, fillarray(1, 2, 7)))*$once(.25, 1, .5, 1, 1),
	step("3B", giminor3, 3+pump(2, fillarray(1, 2, 7)))*$once(1, .25, 1, 2, 1))
endif

gkbetweenmore_ph linseg 0, 35, 1
gkbetweenmore_freq = gkbeatf/8

	endin
	start("score")

	
	instr route

getmeout("betweenmore")

	endin
	start("route")

