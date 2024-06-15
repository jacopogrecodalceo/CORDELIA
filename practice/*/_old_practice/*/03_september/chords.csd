	instr Score

gkpulse	= 75

if (eu(7, 8, 16, "heart") == 1) then
	e("puck",
	gkbeats,
	pump(8, fillarray($ff, $mf, $ff, $f, $fff, 0)),
	step("3Ab", giminor3, pump(8, fillarray(1, 0, 1, 2, 3, 0)), pump(1, fillarray(0, 2, -3, 0))),
	step("3Ab", giminor3, pump(8, fillarray(3, 0, 3, 0, 5, 0)), pump(1, fillarray(0, 2, -3, 0))),
	step("3Ab", giminor3, pump(8, fillarray(5, 7, 6, 5, 7, 0)), pump(1, fillarray(0, 2, -3, 0))))
endif

if (eu(15, 16, 8, "heart") == 1) then
	e("repuck",
	gkbeats,
	pump(8, fillarray($ff, $f, $ff, $f, $fff, $f)),
	step("2Ab", giminor3, pump(8, fillarray(1, 2, 1, 0, 3, 2)), pump(1, fillarray(0, 2, -3, 0))),
	step("2Ab", giminor3, pump(8, fillarray(3, 0, 3, 0, 5, 0)), pump(1, fillarray(0, 2, -3, 0))),
	step("2Ab", giminor3, pump(8, fillarray(5, 7, 6, 5, 7, 0)), pump(1, fillarray(0, 2, -3, 0))))
endif

if (eu(9, 16, 2, "heart") == 1) then
	e("fairest",
	gkbeats*4,
	$mf,
	step("4Ab", giminor3, pump(8, fillarray(1, 2, 1, 2, 3, 2)), pump(1, fillarray(0, 2, -3, 0))))
endif

givemednb(8, $ff, "heart")
givemednb(12, $pp, "heart")

	endin
	start("Score")

	instr Route
getmeout("puck")
getmeout("repuck")
getmeout("fairest")
getmeout("drum")
	endin
	start("Route")
