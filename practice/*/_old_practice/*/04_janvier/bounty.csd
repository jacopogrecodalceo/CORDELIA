	instr score

gkpulse	= 95 + lfo(15, randomi:k(-15, 15, .005))

$if	eu(3, 8, 8, "heart") $then
	e("mecha",
	gkbeats*3.5,
	$f,
	pump(4, fillarray(1, 2, 1)))
endif

$if	eu(3, 8, 16, "heart") $then
	e("aaron",
	gkbeats/5,
	$ff,
	step("2G", gilocrian, pump(32, fillarray(1, 2, 11, 9))),
	step("2E", gidorian, pump(16, fillarray(1, 7, 9, 13, 2, 2, 1)), lfo(5, 35)))
endif

$if	eu(2, 8, 16, "heart") $then
	e("aaron",
	gkbeats/5,
	$fff,
	step("3E", gilocrian, pump(16, fillarray(1, 2, 11))),
	step("2G", gilocrian, pump(16, fillarray(1, 2, 11))))
endif

$if	eu(3, 12, 32, "heart") $then
	e("repuck",
	gkbeats/4,
	$mp,
	step("3E", gilocrian, pump(16, fillarray(1, 2, 11))),
	step("5G", gilocrian, pump(16, fillarray(1, 2, 11))))
endif

	endin
	start("score")

	instr route
	endin

	start("route")
