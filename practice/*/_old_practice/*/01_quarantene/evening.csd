	instr Score

kch	= pump(1, fillarray(0, 1))

if (eu(4, pump(4, fillarray(4, 6)), 16, "heart") == 1) then
	e("puck",
	pump(pump(4, fillarray(32, 48, 16)), fillarray(gkbeats*2, gkbeats)),
	pump(pump(4, fillarray(32, 48, 16)), fillarray($ff, $mf)),
	step("2B", giflamenco, pump(1, fillarray(1, 2, -1))),
	step("3B", giflamenco, pump(1, fillarray(3, 5, 1))),
	step("3B", giflamenco, pump(1, fillarray(5, 3, 2))+kch))
endif

if (eu(16, 16, 16, "heart") == 1) then
	e("fairest",
	gkbeats/2,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($f, $p)),
	step("3B", giflamenco, pump(1, fillarray(1, 2, -1))),
	step("4B", giflamenco, pump(1, fillarray(3, 5, 1))),
	step("3B", giflamenco, pump(1, fillarray(5, 3, 2))+kch))
endif

	endin
	start("Score")

	instr Route
getmeout("puck")
getmeout("fairest")
	endin
	start("Route")
