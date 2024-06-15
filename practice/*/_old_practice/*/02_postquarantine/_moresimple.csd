	instr Score

#pulse	= 75

if (eu(15, 16, 16, "heart") == 1) then
	e("puck",
	gkbeats/4,
	$mf,
	subsc("3D", 9, pump(4, fillarray(1, 3, 2))),
	subsc("3D", 8, pump(4, fillarray(1, 3, 3, 2))))
endif

if (eu(9, 16, 16, "heart") == 1) then
	e("puck",
	gkbeats/6,
	$ff,
	subsc("4D", 6, pump(4, fillarray(2, 1, 3))),
	subsc("5D", 8, pump(4, fillarray(5, 2, 7, 4, 5))))
endif

	endin
	start("Score")

	instr Route
getmeout("puck")
	endin
	start("Route")
