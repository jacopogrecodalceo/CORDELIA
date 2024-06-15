	instr score

k1	go 1, 95, .25

gkpulse	= 125-(((chnget:k("heart")*16)%1)>k1 ? 100 : 0)

if (eu(16, 16, 8, "heart") == 1) then
	eva("repuck",
	gkbeats*once(fillarray(.5, .5, .5, 4)),
	accent(3, $fff),
	giclassic$atk(5),
	step("3D", giminor3, pump(4, fillarray(1, 3, -1, 2))-1)*once(fillarray(2, 4, 2)),
	step("3D", giminor3, pump(2, fillarray(1, 3, -1, 2))-1)*once(fillarray(1, 2, 4, 2)),
	step("3D", giminor3, pump(2, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))
endif

if (eu(12, 16, 16, "heart") == 1) then
	eva("puck",
	gkbeats*once(fillarray(1, 1, 4)),
	accent(3, $p, $pppp),
	gilikearev$atk(5),
	step("3D", giminor3, pump(4, fillarray(1, 3, -1, 2))-1)*once(fillarray(2, 4, 2)),
	step("4D", giminor3, pump(2, fillarray(1, 3, -1, 2))-1)*once(fillarray(1, 2, 4, 2)),
	step("2D", giminor3, pump(2, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))
endif

if (eu(8, 16, 4, "heart") == 1) then
	eva("aaron",
	gkbeats*once(fillarray(.25, .25, .25, 8)),
	accent(3, $p),
	giclassic$atk(5),
	step("3D", giminor3, pump(4, fillarray(1, 3, -1, 2))-1)*once(fillarray(2, 4, 2)),
	step("3D", giminor3, pump(2, fillarray(1, 3, -1, 2))-1)*once(fillarray(1, 2, 4, 2)),
	step("3D", giminor3, pump(2, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))
endif

	endin
	start("score")

	instr route
getmeout("repuck")
getmeout("puck")
getmeout("aaron")
	endin
	start("route")
