	instr score

gkpulse	= 135/2

k1	pump 4, fillarray(0, -5)
k2	= 8

katk	lfse .25, 3, gkbeatf/96

$if	eu(4, 16, 16, "heart") $then
	e("wendi",
	gkbeats*katk,
	accent(4),
	gieclassic$atk(15),
	step("2E", giminor3, pump(k2-1, fillarray(1, 2, 7, 1, 3, 7)), k1))
endif

k3	pump 4, fillarray(16, 16, 16, 16, 16, 15, 14, 13)

$if	eu(5, 16, k3, "heart") $then
	e("wendj",
	gkbeats*katk,
	accent(4),
	gieclassic$atk(5),
	step("3B", giminor3, pump(k2, fillarray(1, 2, 7, 1, 3, 7)), k1),
	step("3A", gimjnor, pump(k2, fillarray(1, 2, 7, 1, 3, 7)), k1),
	step("3E", giminor, pump(k2-3, fillarray(1, 2, 7, 1, 3, 7)), k1))
endif

$if	eu(3, 8, 16, "heart") $then
	e("ipercluster",
	gkbeats*once(fillarray(0, 0, (3-katk)*random(1, 3))),
	accent(4),
	gilikearev,
	step("4E", gimjnor, pump(k2, fillarray(1, 2, 7, 1, 3, 7)), k1),
	step("4E", giminor, pump(k2-3, fillarray(1, 2, 7, 1, 3, 7)), k1),
	step("4E", giminor3, pump(k2-1, fillarray(1, 2, 7, 1, 3, 7)), k1))
endif

$if	eu(3, 8, 16, "heart", 1) $then
	e("ipercluster",
	gkbeats*once(fillarray(0, 0, (3-katk)*random(1, 3))),
	$fff,
	gieclassicr,
	step("1E", gimjnor, pump(k2, fillarray(1, 2, 7, 1, 3, 7)), k1),
	step("1E", giminor, pump(k2-3, fillarray(1, 2, 7, 1, 3, 7)), k1),
	step("1E", giminor3, pump(k2-1, fillarray(1, 2, 7, 1, 3, 7)), k1))
endif

	endin
	start("score")

	instr route
getmeout("ipercluster")
getmeout("wendi")
getmeout("wendj")
	endin
	start("route")
