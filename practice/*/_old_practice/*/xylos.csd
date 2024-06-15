	instr score

gkpulse = 120

if (eu(16, 16, 16, "heart") == 1) then
	e("xylo",
	gkbeats/2,
	accent(3, $f),
	giclassic,
	step("3E", giminor3, pump(8, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))
endif

	endin
	start("score")

	instr route
getmeout("xylo")
getmeout("puck")
	endin
	start("route")
