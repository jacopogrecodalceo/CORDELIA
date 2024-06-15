	instr score
$if	eu(5, 16, pump(8, fillarray(16, 6, 4)), "heart") $then
	e("circle",
	gkbeats/pump(32, fillarray(1, .25, .5)),
	pump(16, fillarray($mp, $ppp)),
	1)
endif

$if	eu(5, 16, pump(8, fillarray(16, 4, 8)), "heart") $then
	e("circle",
	gkbeats*4,
	pump(32, fillarray($fff, $mf)),
	1)
endif

givemednb(8, $ff, "heart")
	endin
	start("score")

	instr route
getmeout("circle")
getmeout("drum")
	endin
	start("route")
