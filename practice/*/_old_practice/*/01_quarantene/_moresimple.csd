	instr Score

kch	= pump(1, fillarray(0, 1, 4))

if (eu(16, 16, 16, "heart") == 1) then
	e("puck",
	gkbeats/2,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($f, $p)),
	step("4C", gkmajor, -2),
	step("4C", gkmajor, 1),
	step("4C", gkmajor, 2+kch))
endif

	endin
	start("Score")

	instr Route
getmeout("puck")
	endin
	start("Route")


