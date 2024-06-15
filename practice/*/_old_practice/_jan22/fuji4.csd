	instr score

gkpulse	= 90

kvar	pump 16, fillarray(1, 2)

$if eu(8, 16, 4*kvar, "heart") $then
	eva("aaron",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 2)))*4,
	accent(3, $f, $ppp),
	giclassic$atk(5),
	step("3D", gikumoi, random:k(1, 15)),
	step("4D", gikumoi, random:k(1, 15)))
endif

	endin
	start("score")

	instr route

resj("aaron", 3/2)
getmeout("aaron")

	endin
	start("route")


