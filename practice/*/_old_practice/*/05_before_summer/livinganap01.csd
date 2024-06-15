	instr score

gkpulse	= 15 + go(0, 125, 45) - timeh(8)

$if	eu(9, 16, 32, "heart") $then
	e("puck",
	gkbeats*once(fillarray(cunti(0, 8*4*4, 1), cunti(0, 8*4*8, 1), 4)),
	$fff,
	-gieclassic$atk(random:k(5, gkbeats/12)),
	step("4C", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("3F", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("3D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))))
endif

$if	eu(9, 16, 32, "heart") $then
	e("cascade",
	gkbeats*once(fillarray(cunti(0, 8*4*4, 1), cunti(0, 8*4*8, 1), 4)),
	$pp,
	-giclassic$atk(random:k(25, gkbeats/12)),
	step("5C", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("4F", gikumoi, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("2D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))))
endif

$if	eu(3, 16, 8, "heart") $then
	e("aaron",
	gkbeats*once(fillarray(cunti(0, 8*4*4, 1), cunti(0, 8*4*8, 1), 8)),
	$mp,
	once(fillarray(gimirror, gieclassic))$atk(random:k(5, gkbeats/8)),
	step("4C", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("3D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))))
endif

	endin
	start("score")

	instr route
moog("puck", lfse(500, go(3, 55, 15)$k, gkbeatf/24), lfse(.25, .85, gkbeatf/32))
moog("cascade", lfse(50, go(1, 95, 15)$k, gkbeatf/32), lfse(.25, .85, gkbeatf/12), comeforme(95))
getmeout("aaron")
	endin
	start("route")
