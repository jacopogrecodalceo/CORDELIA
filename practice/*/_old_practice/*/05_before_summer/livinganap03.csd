	instr score

gkpulse	= 15 + go(0, 125, 75) - timeh(8)

$if	eu(9, 16, 8, "heart") $then
	e("ipercluster",
	gkbeats*once(fillarray(cunt(0, 8*4*4, 1), cunt(0, 8*4*8, 1), 12)),
	$ff,
	once(fillarray(-gieclassic, gimirror, gilikearev))$atk(random:k(5, gkbeats/12)),
	step("1C", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("4E", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("3D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))))
endif

$if	eu(5, 16, 8, "heart", 3) $then
	e("ipercluster",
	gkbeats*once(fillarray(cunti(0, 8*4*4, 1), cunt(0, 8*4*8, 1), 24)),
	$ff,
	once(fillarray(-gieclassic, gilikearev))$atk(random:k(5, gkbeats/12)),
	step("1D", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("5D", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("3F", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("2C", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))))
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

	endin
	start("score")

	instr route
moog("ipercluster", lfse(500, go(3, 55, 15)$k, gkbeatf/24), lfse(.25, .85, gkbeatf/32))
getmeout("ipercluster", oscil(1, gkbeatf/8, gilowtri))
moog("cascade", lfse(350, go(1, 95, 15)$k, gkbeatf/32), lfse(.25, .85, gkbeatf/12), comeforme(95))
	endin
	start("route")
