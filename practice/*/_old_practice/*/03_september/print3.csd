	instr Score

gkpulse	= 75

if (eu(7, 8, 8, "heart") == 1) then
	e("puck",
	gkbeats,
	$f,
	step("3Ab", giminor, pump(8, fillarray(1, 0, 1, 0, 3, 0))),
	step("3Ab", giminor, pump(8, fillarray(3, 0, 3, 0, 5, 0))),
	step("3Ab", giminor, pump(8, fillarray(5, 7, 6, 5, 7, 0))))
endif

if (eu(7, 8, 8, "heart") == 1) then
	e("puck",
	gkbeats,
	$f,
	step("3Ab", giminor3, pump(8, fillarray(1, 0, 1, 0, 3, 0))),
	step("3Ab", giminor3, pump(8, fillarray(3, 0, 3, 0, 5, 0))),
	step("3Ab", giminor3, pump(8, fillarray(5, 7, 6, 5, 7, 0))))
endif

	endin
	start("Score")

	instr Route
getmeout("repuck")
	endin
	start("Route")
