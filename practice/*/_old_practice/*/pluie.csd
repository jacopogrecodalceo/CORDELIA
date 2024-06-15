	instr score


gkpulse	= 80 - (phasor:k(.5)>.5 ? 50 : 0)

$if	eu(5, 16, 16, "heart") $then
	e("bee",
	gkbeats*random:k(1, 8)*once(fillarray(0, 0, 0, 0, 0, 0, 1, 1, 1))*8,
	accent(5, $ff),
	gilikearev$atk(5),
	step("2C", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))),
	step("1Eb", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif

$if	eu(9, 16, 32, "heart") $then
	e("bee",
	gkbeats*random:k(1, 8)*once(fillarray(0, 0, 0, 0, 0, 0, 1, 1, 1)),
	accent(3, $p),
	gilikearev$atk(5),
	step("5B", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))),
	step("5Eb", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif
	endin
	start("score")

	instr route

flingue("ohoh", oscil:k(25, gkbeatf/12, gikazan))
getmeout("bee")
	endin
	start("route")
