	instr score

gkpulse	= 105

$if	eu(8, 8, 16, "heart") $then
	e("cascadexp",
	gkbeats,
	$mf,
	step("4Ab", gipentamin, pump(27, fillarray(1, 2, 3, 4, 5)-7)),
	step("4Ab", gipentamin, pump(28, fillarray(1, 2, 3, 4, 5)-5)),
	step("4Ab", gipentamin, pump(29, fillarray(1, 2, 3, 4, 5)-3)),
	step("4Ab", gipentamin, pump(30, fillarray(1, 2, 3, 4, 5))))
endif

$if	eu(1, 8, 6, "heart") $then
	e("aaron",
	gkbeats*10,
	$ff,
	step("5Ab", gipentamin, pump(29, fillarray(1, 2, 3, 4, 5)-3)),
	step("2Eb", gipentamin, pump(30, fillarray(1, 2, 3, 4, 5))))
endif

	endin
	start("score")
	instr route
getmeout("cascadexp")
getmeout("aaron")
	endin
	start("route")
