	instr Score

kran	= 8 * int(random:k(-2, 2))

if (eu(16, 16, 16, "heart") == 1) then
	e("puck",
	gkbeats/2,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($f, $mf)),
	step("4C", gkionian, pump(64, fillarray(1, 3, 5, 8)) + pump(2, fillarray(0, -2, 1, -5)) + kran))
endif

if (eu(3, 16, 4, "heart") == 1) then
	e("witches",
	gkbeats*8,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($ff, $ppp)),
	step("3G", gkionian, pump(64, fillarray(1, 3, 5, 8)) + pump(2, fillarray(0, -2, 1, -5)) + kran))
endif

if (eu(9, 16, 16, "heart") == 1) then
	e("snug",
	gkbeats/4,
	$fff,
	step("3C", gkionian, pump(16, fillarray(1, 3, 5, 8)) + pump(2, fillarray(0, -2, 1, -5)) + kran))
endif

	endin
	start("Score")

	instr Route

getmeout("witches")
getmeout("puck")
getmeout("snug", hlowa(1, 8))

	endin
	start("Route")
