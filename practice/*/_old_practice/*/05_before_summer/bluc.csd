	instr score

gkpulse	= 130 + randomi(-5, 15, gkbeatf/32)

kndx	pump 2, fillarray(0, -2, -4)

$if	eu(8, 16, 16, "heart") $then
	e("wendi",
	gkbeats*once(fillarray(cunt(.25, 8*24, 1), 2)),
	accent(4)*cunt(0, 8*32, 1),
	gieclassic$atk(15),
	step("3A", gipentamin, pump(32, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("3D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif

$if	eu(8, 16, 16, "heart", lfa(2, gkbeatf/8)) $then
	e("wendj",
	gkbeats*once(fillarray(cunt(.25, 8*24, 1), 2)),
	accent(4)*cunt(0, 8*32, 1),
	giclassic$atk(15),
	step("3A", gipentamin, pump(32, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("3D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif

$if	eu(3, 16, pump(8, fillarray(64, 32)), "heart", lfa(4, gkbeatf/8)) $then
	e("repuck",
	gkbeats/random(2, 8)*cunti(0, 8*16, 1),
	accent(4, $fff),
	giclassic$atk(5),
	step("3A", gipentamin, pump(32, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("3D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif
	endin
	start("score")

	instr route
getmeout("wendi")
getmeout("wendj")
getmeout("aaron")
getmeout("repuck")
	endin
	start("route")
