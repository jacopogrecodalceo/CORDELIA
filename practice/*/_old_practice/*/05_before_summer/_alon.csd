	instr score

gkpulse	= 135

klfo	lfse .215, .115, gkbeatf/16

$if	eu(16, 16, 16, "heart") $then
	e("toomuchalone",
	gkbeats*klfo,
	accent(3),
	gieclassic$atk(5),
	step("4D", giminor3, once(fillarray(1, 3, 2, 7, 5, 2)+pump(2, fillarray(0, -4)))))
endif

$if	eu(16, 16, 16, "heart") $then
	e("repuck",
	gkbeats*once(fillarray(.15, .5, 1)),
	accent(3, $fff),
	gieclassic$atk(5),
	step("4D", giminor3, once(fillarray(2, 7, 5, 2, 1, 3)))/once(fillarray(1, 2, 4)),
	step("4D", giminor3, once(fillarray(3, 2, 7, 5, 2, 1)))/once(fillarray(1, 2, 4)),
	step("4D", giminor3, once(fillarray(1, 3, 2, 7, 5, 2)))/once(fillarray(1, 2, 4)))
endif

	endin
	start("score")

	instr route
getmeout("toomuchalone", hlowa(1, gkbeatf/8, .25))
flingue3("toomuchalone", lfse(0, 5, gkbeatf/4), .95, hlowa(1, gkbeatf/8))
getmeout("repuck", hlowa(1, gkbeatf/8))
flingue3("repuck", lfse(0, 5, gkbeatf/4), .95, hlowa(1, gkbeatf/8, .25))
	endin
	start("route")
