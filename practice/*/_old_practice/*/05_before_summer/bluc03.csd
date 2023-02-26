	instr score

gkpulse	= 145 + randomi(-5, 5, gkbeatf/32)

kndx	pump 2, fillarray(0, -2, -4)

k1	= .25+lfa(.35, gkbeatf/64)
k2	= k1

ki	= 4
kj	= 0

katk	= 5+lfa(25, gkbeatf/64)

kdyn	lfa 1, gkbeatf/64

$if	eu(9, 16, 16, "heart") $then
	e("wendi",
	gkbeats*once(fillarray(k1, k2+ki)),
	accent(5, $p)*kdyn,
	once(fillarray(gieclassic, gieclassicr)),
	step("3A", gipentamin, pump(32, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("3D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif

$if	eu(4, 16, 16, "heart") $then
	e("wendj",
	gkbeats*once(fillarray(k1, k2+kj)),
	accent(8, $p)*kdyn,
	once(fillarray(gieclassic, gikazan)),
	step("3A", gipentamin, pump(32, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("3D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif

$if	eu(4, 16, 16, "heart") $then
	e("aaron",
	gkbeats*2,
	accent(4, $fff, .35),
	gieclassic,
	step("5A", gipentamin, pump(16, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("5D", giminor3, pump(16, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif

$if	eu(4, 16, 16, "heart", 2) $then
	e("aaron",
	gkbeats*2,
	accent(4, $fff, .35),
	giclassic,
	step("5A", gipentamin, pump(16, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("5D", giminor3, pump(16, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif

$if	eu(3, 16, 16, "heart") $then
	e("repuck",
	gkbeats*3,
	accent(3),
	giclassic,
	step("2A", gipentamin, pump(16, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("2D", giminor3, pump(16, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
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
