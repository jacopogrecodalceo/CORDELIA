	instr score

gkpulse	= 75

$if	eu(6, 16, 64, "heart") $then
	e("repuck",
	gkbeats*once(fillarray(3, 1)),
	accent(3, $ff),
	gieclassic$atk(5),
	pump(5, fillarray(110, 140))*once(fillarray(1, 9/8, 6/5, 3/2, 8/5)))
endif

$if	eu(5, 16, 32, "heart") $then
	e("bee",
	gkbeats*2,
	accent(5, $fff),
	gieclassic$atk(5),
	pump(10, fillarray(110, 140))*once(fillarray(1, 9/8, 6/5, 3/2, 8/5))*3/4)
endif

	endin
	start("score")

	instr route
getmeout("bee")
getmeout("aaron")
getmeout("repuck")
flingue("bee", lfse(0, 5, gkbeatf/64), .75, lfa(.5, gkbeatf/128))
	endin
	start("route")
