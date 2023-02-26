	instr score

gkpulse	= 105

k1	pump	4, fillarray(1, 2, 0)

$if	eu(5, 16, pump(4, fillarray(16, 6, 32, 16, 6)), "heart") $then
	e("aaron",
	gkbeats*pump(64, fillarray(1, 5, 0, .5, .5)),
	pump(32, fillarray($f, $mf)),
	step("3Ab", giminor3, pump(pump(4, fillarray(48, 45)), fillarray(1, 2, 7, 1, 3, 7) - k1)))
endif

kstep	= pump(8, fillarray(0, 2))

$if	eu(5, 16, pump(8, fillarray(16, 32, 16)), "heart") $then
	e("aaron",
	gkbeats*pump(32, fillarray(1, 0, .5)),
	pump(16, fillarray($f, $p)),
	step("2Ab", giminor3, pump(32, fillarray(5, 5, 0, 5, 5, 0)), kstep-12),
	step("2Ab", giminor3, pump(48, fillarray(5, 5, 0, 5, 5, 0)), kstep))
endif

$if	eu(5, 16, 16, "heart") $then
	e("fairest",
	gkbeats*pump(64, fillarray(1, 2, .25)),
	$fff,
	step("1Ab", giminor3, pump(32, fillarray(5, 5, 0, 5, 5, 0)), kstep),
	step("1Ab", giminor3, pump(48, fillarray(5, 5, 0, 5, 5, 0)), kstep))
endif

$if	eu(2, 16, 6, "heart") $then
	e("witches",
	gkbeats*pump(64, fillarray(1, 9, .25)),
	$p,
	step("3Ab", giminor3, 1, kstep),
	step("4Ab", giminor3, 1, kstep))
endif
	endin
	start("score")

	instr route

a1	a	lfse(.05, go(.15, 45, .5), gkbeatf/go(3, 95, 6))

flingue("aaron", a1, lfse(.15, .75, gkbeatf/go(12, 85, 2)), portk(pump(24, fillarray(1, 0, 0)), .05))
getmeout("aaron")
getmeout("fairest")
flingue("fairest", a1, lfse(.15, .75, gkbeatf/go(2, 155, 48)), portk(pump(48, fillarray(1, 0, 1)), .05))

getmeout("witches", comeforme(125))
	endin
	start("route")
