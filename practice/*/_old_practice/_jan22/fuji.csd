	instr score

gkpulse	= 110

kvar	pump 16, fillarray(1, 2)

$if eu(8, 16, 16*kvar, "heart") $then
	eva("fuji",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 2)))/kvar,
	accent(3, $p),
	giclassic,
	step("3D", gikumoi, random:k(1, 15)),
	step("4D", gikumoi, random:k(1, 15)))
endif

$if eu(4, 16, 8, "heart") $then
	eva("fuji",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 1)))*8,
	accent(4, $fff),
	giclassic$atk(5),
	step("2D", gikumoi, pump(2, fillarray(1, 1, 3, 2))))
endif

$if eu(4, 16, 12, "heart") $then
	eva("wendj",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 1)))*4,
	accent(4, $pp),
	gieclassic,
	step("2D", gikumoi, pump(2, fillarray(1, 1, 3, 2))))
endif

$if eu(4, 16, 4, "heart", 4) $then
	eva("aaron",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 1)))*8,
	accent(4, $mf),
	giclassic$atk(5),
	step("4D", gikumoi, 1+pump(2, fillarray(1, 2, 3, 4, 3, 3, 4, 4))))
endif

	endin
	start("score")

	instr route
getmeout("aaron")
getmeout("wendj")

getmeout("fuji")
	endin
	start("route")


