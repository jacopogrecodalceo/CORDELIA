	instr score

gkpulse	= 15 + go(0, 65, 75) - timeh(16)

kndx	cosseg 0, 95, 1

$if	eu(9, 16, 32, "heart") $then
	e("puck",
	gkbeats*once(fillarray(cunti(0, 8*4*4, 1), cunti(0, 8*4*8, 1), 4)),
	$fff,
	morpheus(kndx, gieclassicr, gieclassic),
	step("3C", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("2F", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("4D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))))
endif

$if	eu(9, 16, 32, "heart") $then
	e("cascade",
	gkbeats*once(fillarray(cunti(0, 8*4*4, 1), cunti(0, 8*4*8, 1), 4)),
	$pp,
	morpheus(kndx, gieclassicr, gieclassic),
	step("2C", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("5F", gikumoi, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("4D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))))
endif

$if	eu(3, 16, pump(32, fillarray(8, 48, 8, 24)), "heart") $then
	e("fim",
	gkbeats*once(fillarray(cunti(0, 8*4*4, 1), cunti(0, 8*4*8, 1), 2)),
	$ppp,
	once(fillarray(gimirror, gieclassic, giclassicr)),
	step("3C", gimajor, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))),
	step("4D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))))
endif

	endin
	start("score")

	instr route
moog("puck", lfse(500, go(3, 55, 15)$k, gkbeatf/24), lfse(.25, .85, gkbeatf/32), fadeaway(45))
moog("cascade", lfse(50, go(1, 95, 9)$k, gkbeatf/12), lfse(.5, .85, gkbeatf/12), comeforme(35))
getmeout("fim", fadeaway(55))
flingue3("fim", lfse(.005, .0015, gkbeatf/24), .85, comeforme(65))
flingue3("puck", lfse(.005, .0015, gkbeatf/24), .85, comeforme(65))
	endin
	start("route")
