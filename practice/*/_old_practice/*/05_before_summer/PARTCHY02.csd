	instr score

gkpulse	= 95

k1	linseg 0, 195, 95, 195, 55
kdur	linseg 1, 195, .25, 95, .15

$if	eu(5, 16, 64, "heart") $then
	e("fim",
	gkbeats*once(fillarray(3, 1, 1, 1, 1))*kdur,
	accent(5, $ff),
	gieclassic$atk(5),
	40*once(fillarray(pump(2.5, fillarray(1, .95, random:k(1, 2), .95, 1, .75, .875)), 9/8, 6/5, 3/2, 8/5))+k1)
endif

	endin
	start("score")

	instr route
getmeout("bee", 2)
getmeout("aaron")
getmeout("fim")
flingue("bee", lfse(0, 5, gkbeatf/64), .75, lfa(.5, gkbeatf/128))
	endin
	start("route")
