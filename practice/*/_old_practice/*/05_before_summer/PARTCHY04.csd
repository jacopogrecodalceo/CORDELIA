	instr score

gkpulse	= 75

k1	= 90 + lfo(50, .0059)

$if	eu(4, 16, 64, "heart") $then
	e("fim",
	gkbeats*once(fillarray(1, .25)),
	accent(4),
	giclassic$atk(5),
	k1*once(fillarray(1, 21/20, 16/15, 4/3, 3/2, 14/9, 8/5, 2)))
endif

$if	eu(4, 16, 64, "heart") $then
	e("fim",
	gkbeats*once(fillarray(1, .25)),
	accent(4),
	giclassic$atk(5),
	k1*once(fillarray(1, 1, 21/20, 16/15, 4/3, 3/2, 14/9, 8/5, 2)))
endif
	endin
	start("score")

	instr route
getmeout("bee")
getmeout("fim")
getmeout("aaron")
getmeout("repuck")
flingue("fim", lfa(5, gkbeatf/64), .5, lfa(1, gkbeatf/128))
	endin
	start("route")
