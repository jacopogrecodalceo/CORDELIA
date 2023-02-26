	instr score

gkpulse = 135-timeh(2)


if (eu(7, 16, 16, "heart") == 1) then
	p(3, "puck",
	gkbeats*random:k(8, 12),
	accent(3, $fff),
	gilikearev$atk(5),
	step("3D", giminor3, random:k(-7, 7)),
	step("4D", giminor3, random:k(-7, 7)))
endif

if (eu(7, 16, 2, "heart") == 1) then
	p(-3, "aaron",
	gkbeats*random:k(8, 12)*once(fillarray(0, 1)),
	accent(3, $ff),
	gilikearev$atk(5),
	step("5D", giminor3, random:k(-7, 7)),
	step("4D", giminor3, random:k(-7, 7)))
endif

if (eu(3, 16, 4, "heart") == 1) then
	e("burd",
	gkbeats*random:k(8, 12),
	accent(3, $pp),
	gikazan,
	step("3D", giminor3, once(fillarray(6, 5, 1, 0, 2))),
	step("4D", giminor3, once(fillarray(7, 0, 0, 2))))
endif
	endin


	start("score")

	instr route
getmeout("puck")
getmeout("aaron")
getmeout("burd")
	endin
	start("route")
