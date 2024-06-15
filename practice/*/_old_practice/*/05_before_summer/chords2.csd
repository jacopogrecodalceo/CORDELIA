	instr score

gkpulse	= 65

k1	pump 2, fillarray(0, -2, -4, -5)

$if	eu(9, 16, 16, "heart") $then
	e("ohoh",
	gkbeats,
	accent(3),
	gieclassic$atk(5),
	step("4B", giminor3, once(fillarray(1, 2))+k1),
	step("4B", giminor3, once(fillarray(5, 3))+k1),
	step("4B", giminor3, once(fillarray(2, 7))+k1))	
endif
$if	eu(9, 16, 8, "heart") $then
	e("alone",
	gkbeats*6,
	accent(5),
	gieclassic,
	step("5B", giminor3, once(fillarray(1, 2))+k1),
	step("5B", giminor3, once(fillarray(5, 3))+k1),
	step("5B", giminor3, once(fillarray(2, 7))+k1))	
endif
$if	eu(9, 16, 32, "heart") $then
	e("ohoh",
	gkbeats/4,
	accent(3)/2,
	giclassic,
	step("3B", giminor3, once(fillarray(1, 2))+k1),
	step("3B", giminor3, once(fillarray(5, 3))+k1),
	step("3B", giminor3, once(fillarray(2, 7))+k1))	
endif

givemednb(32, $mf, "heart")

	endin
	start("score")

	instr route
getmeout("ohoh")
flingue("ohoh", randomi:k(1, 195, .5), randomi:k(.25, .95, .5))
flingue("drum", randomi:k(1, 25, .5), randomi:k(.25, .95, .5))
getmeout("alone")
flingue3("alone", randomi:k(1, 195, .5), randomi:k(.25, .95, .5))
	endin
	start("route")
