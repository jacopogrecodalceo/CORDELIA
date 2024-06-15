	instr score

gkpulse	= 115*.75

$if eu(7, 16, 16, "heart") $then
	e("mecha",
	gkbeats/4, 
	$fff,
	pump(6, fillarray(1, 4, 4, 3, 2)))
endif

$if eu(9, 16, 16, "heart", 2) $then
	e("aaron",
	gkbeats/int(randomi:k(1, 8, 125)), 
	pump(32, fillarray($f, $ppp)),
	step("5D", gidorian, pump(4, fillarray(1, 4, 3, 2)), lfo(2, 512)),
	step("4D", gidorian, pump(5, fillarray(1, 4, 3, 2))))
endif

	endin
	start("score")

	instr route
getmeout("mecha")
getmeout("aaron")
	endin
	start("route")
