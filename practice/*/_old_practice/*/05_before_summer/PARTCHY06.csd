	instr score

gkpulse	= 95

k1	= 110

kdur	= .05+linseg(0, 95, 1)

$if	eu(9, 16, 16, "heart") $then
	e("toomuchalone",
	gkbeats*once(fillarray(4, .5))*kdur,
	accent(3, $p),
	gieclassic$atk(5),
	k1*table(once(fillarray(0, 2, 3, 0, 2)), giolympos)*4)
endif

$if	eu(9, 16, 16, "heart") $then
	e("supercluster",
	gkbeats*once(fillarray(5, .5))*kdur,
	accent(3, $mf),
	gieclassic$atk(5),
	k1*table(once(fillarray(0, 2, 3, 0, 2)), giolympos)*2)
endif

$if	eu(9, 16, 16, "heart", 3) $then
	e("supercluster",
	gkbeats*once(fillarray(1, .5))*kdur,
	accent(3, $mf),
	gieclassic$atk(5),
	step("4B", gipentamin, once(fillarray(1, 2, 4, 1, 2))),
	step("3E", gipentamin, once(fillarray(1, 2, 4, 1, 2))))
endif

$if	eu(9, 16, 16, "heart", 1) $then
	e("supercluster",
	gkbeats*once(fillarray(1, .5))*kdur,
	accent(3, $mf),
	gieclassic$atk(5),
	step("2A", gipentamin, once(fillarray(1, 2, 4, 1, 2))))
endif

$if	eu(9, 16, 8, "heart", 2) $then
	e("supercluster",
	gkbeats*once(fillarray(1, .5))*4*kdur,
	accent(3, $p),
	gieclassic$atk(5),
	step("1A", gipentamin, once(fillarray(1, 2, 4, 1, 2))))
endif

	endin
	start("score")

	instr route
getmeout("ohoh")
getmeout("fim")
getmeout("supercluster")
getmeout("toomuchalone")
getmeout("repuck")
flingue("fim", lfa(115, gkbeatf/128), .5, lfa(.45, gkbeatf/128))
	endin
	start("route")
