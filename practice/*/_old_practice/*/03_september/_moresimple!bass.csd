	instr Score

gkpulse	= 125

if (eu(16, 16, 8, "heart") == 1) then
	e("repuck",
	gkbeats/4,
	$f,
	step("2D", giminor, pump(2, fillarray(1, 3, -1, 2))))
endif

	endin
	start("Score")

	instr Route
getmeout("repuck")
	endin
	start("Route")
