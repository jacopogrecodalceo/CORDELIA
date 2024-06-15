	instr score

gkpulse	= 105 + ((randomh(-15, 15, gkbeatf)-timeh(16))*fadeaway(55))

kdur	expseg 4, 15, 1

$if	eu(8, 16, 32, "heart") $then
	e("click",
	gkbeats*once(fillarray(1, 4, .5, .5, .5, .5, .5, .5))/kdur,
	accent(4),
	giclassic$atk(cunt(65, 32*4, 5)),
	step("4D", gimjnor, pump(64, fillarray(1, 2, 7, 1, 3, 7)), pump(2, (fillarray(0, -12)))),
	step("4D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(3, (fillarray(0, -12)))))
endif

$if	eu(5, 16, 32, "heart", 1) $then
	e("clickf",
	gkbeats*once(fillarray(1, 4, .5, .5, .5, .5, .5, .5))/kdur,
	accent(4),
	giclassic$atk(cunt(65, 32*4, 5)),
	step("3D", gimjnor, pump(64, fillarray(1, 2, 7, 1, 3, 7)), pump(2, (fillarray(0, -12)))),
	step("3D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(3, (fillarray(0, -12)))))
endif

$if	eu(5, 16, 32, "heart", 1) $then
	e("mecha",
	gkbeats*once(fillarray(1, 4, .5, .5, .5, .5, .5, .5))/8,
	accent(4),
	giclassic$atk(cunt(65, 32*4, 5)),
	once(fillarray(1, 2, 3, 1, 4)))
endif
	endin
	start("score")

	instr route
getmeout("click")
getmeout("clickf")
getmeout("mecha")
	endin
	start("route")
