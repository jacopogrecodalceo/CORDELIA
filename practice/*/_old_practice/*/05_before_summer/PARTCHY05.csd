	instr score

gkpulse	= 75

k1	= 90 + lfo(35, .001595)

$if	eu(9, 16, 32, "heart") $then
	e("fim",
	gkbeats*once(fillarray(1, .5))*cunt(.25, 91, 1),
	accent(3, $p),
	gieclassic$atk(5),
	k1*table(once(fillarray(0, 2, 3, 0, 2)), giolympos)*2)
endif

$if	eu(9, 16, 32, "heart") $then
	e("repuck",
	gkbeats*once(fillarray(1, .5))*cunt(.25, 91, 2),
	accent(3, $p),
	giclassic$atk(5),
	k1*table(once(fillarray(1, 2, 3, 0, 2)), giolympos)+k1*3*table(once(fillarray(1, 2, 3, 1, 2)), giolympos))
endif

$if	eu(6, 16, 8, "heart") $then
	e("fim",
	gkbeats*once(fillarray(.75, 1)),
	accent(6, $p),
	gieclassic$atk(5),
	k1*table(once(fillarray(0, 2, 3, 4, 1)), giolympos))
endif

$if	eu(6, 16, 4, "heart") $then
	e("bee",
	gkbeats*once(fillarray(1, .75))*8,
	accent(3, $ff),
	gieclassic$atk(5),
	k1*table(once(fillarray(1, 2, 3, 4, 2, 1)), giolympos)*4)
endif
	endin
	start("score")

	instr route
getmeout("bee")
getmeout("fim")
getmeout("repuck")
getmeout("repuck")
flingue("fim", lfa(115, gkbeatf/128), .5, lfa(.45, gkbeatf/128))
	endin
	start("route")
