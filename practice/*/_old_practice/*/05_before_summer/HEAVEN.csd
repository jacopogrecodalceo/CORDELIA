	instr givememmore
gkndx	lfa, 2, gkbeatf/64
	endin
	start("givememmore")

	instr score

gkpulse	= portk(randomh:k(9, 125, gkbeatf), gkbeats, 35) + randomi(-5, 5, gkbeatf/64)
kmore	go 1, 65, 8
katk	go 25, 45, 5

$if	eu(8, 16, 32, "heart") $then
	e("wendi",
	gkbeats*once(fillarray(kmore, 1)),
	accent(8),
	once(fillarray(gilikearev, gieclassic))$atk(katk),
	step("3D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, 1, 2))-pump(8, fillarray(0, -2, -8, 2))-pump(1, fillarray(0, -2, -8, 2))))
endif

$if	eu(8, 16, 32, "heart", lfa(2, gkbeatf/8)) $then
	e("cascadexp",
	gkbeats*once(fillarray(kmore, 1, 1)),
	accent(8),
	once(fillarray(gieclassicr, gilikearev, gieclassic))$atk(katk),
	step("2D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, 1, 2))-pump(8, fillarray(0, -2, -8, 2))-pump(1, fillarray(0, -2, -8, 2))))
endif

$if	eu(8, 16, 32, "heart", lfa(4, gkbeatf/32)) $then
	e("ipercluster",
	gkbeats*once(fillarray(kmore, 0, 0, 1)),
	accent(8, $mp),
	once(fillarray(-gilikearev, -gieclassic))$atk(katk),
	step("2F", gipentamaj, pump(32, fillarray(1, 2, 7, 1, 3, 7, 1, 2))-pump(8, fillarray(0, -2, -8, 2))-pump(1, fillarray(0, -2, -8, 2))))
endif
	endin
	start("score")

	instr route
getmeout("wendi")
getmeout("cascadexp")
getmeout("ipercluster")
	endin
	start("route")
