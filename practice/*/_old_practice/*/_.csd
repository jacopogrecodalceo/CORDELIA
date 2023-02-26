	instr score

gkpulse = 120


if (eu(7, 16, 4, "heart") == 1) then
	e("aaron",
	gkbeats*random:k(8, 12),
	accent(3, $f),
	gilikearev$atk(5),
	step("4D", giminor3, random:k(1, 7)),
	step("4D", giminor3, random:k(1, 7)))
endif


if (eu(7, 16, 24, "heart") == 1) then
	e("xylo",
	gkbeats/random:k(8, 12),
	accent(3, $f),
	gilikearev$atk(5),
	step("2D", giminor3, random:k(1, 7))*once(fillarray(1, 2, 4)),
	step("3D", giminor3, random:k(1, 7))*once(fillarray(1, 2, 4)))
endif

	endin


	start("score")

	instr route
getmeout("aaron")
getmeout("xylo")
	endin
	start("route")
