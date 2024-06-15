	instr score

gkpulse	= 35

kndx	pump 1, fillarray(0, -2, -4, 2)

kdur	random 3, 10

$if	eu(2, 4, 5, "heart") $then
	e("aaron",
	gkbeats*kdur,
	$ff,
	gieclassic,
	step("4A", gipentamin, pump(32, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("5D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif
$if	eu(2, 4, 5.15, "heart") $then
	e("click",
	gkbeats*kdur,
	$p,
	gikazan,
	step("4A", gipentamin, pump(32, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("5D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif
$if	eu(2, 4, 5, "heart") $then
	e("fim",
	gkbeats*kdur,
	$f,
	gieclassic,
	step("2A", gipentamin, pump(16, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("3A", gipentamin, pump(32, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("3D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif
$if	eu(2, 4, 5, "heart") $then
	e("cascade",
	gkbeats*kdur,
	$f,
	gispina,
	step("5D", gipentamin, pump(16, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("6A", gipentamin, pump(32, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("4D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif
$if	eu(2, 4, 1, "heart") $then
	e("witches",
	gkbeats*kdur*2,
	$p,
	-giclassic,
	step("2D", gipentamin, pump(16, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("2A", gipentamin, pump(32, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("3D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif
$if	eu(2, 4, 5.15, "heart") $then
	e("fim",
	gkbeats*kdur,
	$f,
	giclassic$atk(5),
	step("0D", gipentamin, pump(16, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("2A", gipentamin, pump(32, fillarray(0, 2, 4, 0, 3, 4, -2, 2)+kndx+1)),
	step("1D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, -2, 2)+kndx)))
endif
	endin
	start("score")

	instr route
getmeout("aaron")
getmeout("click")
getmeout("fim")
getmeout("cascade")
getmeout("witches")
	endin
	start("route")
