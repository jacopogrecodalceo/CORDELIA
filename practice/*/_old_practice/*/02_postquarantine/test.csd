	instr Score

#pulse = 75

kch	= pump(4, fillarray(0, 1, 4))

if (eu(16, 16, 16, "heart") == 1) then
	e("repuck",
	gkbeats/2,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($f, $p)),
	step("4B", #minor, -2),
	step("4B", #minor, 1),
	step("4B", #minor, 2+kch))
endif

	endin
	start("Score")

	instr Route
getmeout("repuck")
	endin
	start("Route")


