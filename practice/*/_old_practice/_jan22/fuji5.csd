	instr score

gkpulse	= 90-timeh(2)

kvar	pump 16, fillarray(1, 2)

$if eu(8, 16, 4*kvar, "heart") $then
	eva("grind2",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 2)))*8,
	accent(3, $f, $ppp),
	giclassic,
	step("1D", giminor, random:k(1, 15)),
	step("3D", giminor, random:k(1, 15)))
endif

	endin
	start("score")

	instr route

getmeout("grind2")

	endin
	start("route")
