	instr Score
if (eu(5, 12, 16, "heart") == 1) then
	e("puck",
	gkbeats,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($f, $p)),
	scall("3G", gilocrian, pump(3, fillarray(3, 3, 2, 2, 7))),
	scall("3Bb", gidorian, pump(3, fillarray(3, 3, 2, 2, 7))),
	scall("3D", gidorian, pump(6, fillarray(3, 3, 2, 2, 7))))
endif
	endin
	start("Score")

	instr Route
getmeout("puck")
	endin
	start("Route")

