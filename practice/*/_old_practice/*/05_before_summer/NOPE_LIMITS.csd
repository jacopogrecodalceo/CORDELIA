	instr score

gkpulse	= 125

$if	eu(8, 16, 32, "heart") $then
	e("puck",
	gkbeats*once(fillarray(1, .5, .45, .5, .2)),
	accent(3),
	once(fillarray(gieclassic, -gilikearev, gikazan, gilikearev))$atk(5),
	step("2D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, 1, 2))+pump(2, fillarray(0, -4, -5, -4))))
endif

	endin
	start("score")

	instr route
getmeout("puck")
	endin
	start("route")
