	instr Score

gkpulse	= 75

if (eu(4, 16, 16, "heart") == 1) then
	e("repuck",
	gkbeats/2,
	$f,
	step("2Ab", giquarter, 1))
endif

if (eu(8, 16, 16, "heart", 1) == 1) then
	e("repuck",
	gkbeats/2,
	$f,
	step("3Db", giquarter, 1))
endif

	endin
	start("Score")

	instr Route
getmeout("repuck")
	endin
	start("Route")
