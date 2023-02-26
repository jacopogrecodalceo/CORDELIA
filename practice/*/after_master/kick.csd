	instr score

gkpulse	= 110

$if eu(5, 8, 8, "heart") $then
	eva("kick", 
	gkbeats*$once(4, .5, .5),
	accent(3, $ff),
	giclassic$atk(5),
	step("2D", giminor, pump(4, fillarray(1, 2, 7))))
endif


$if eu(5, 8, 16, "heart") $then
	eva("simki", 
	gkbeats*$once(4, .5, .5),
	accent(3, $ff),
	giclassic,
	step("4D", giminor, pump(4, fillarray(1, 2, 7))))
endif

	endin
	start("score")

	
	instr route

getmeout("kick")
getmeout("simki")

	endin
	start("route")

