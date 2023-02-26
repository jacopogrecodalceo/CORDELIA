	instr score

kup	lfo 5, gkbeatf/4, 1

$if	eu(4, 7, 8, "heart") $then
	e("aaron",
	gkbeats*4,
	$pp,
	step("3F", giwhole, pump(15, fillarray(5, 0, 3)+kup)),
	step("2Bb", giwhole, pump(16, fillarray(5, 0, 3)+kup)))
endif

$if	eu(3, 7, 8, "heart", 2) $then
	e("cascadexp",
	gkbeats*random:k(1, 12),
	$p,
	step("3F", giwhole, random:k(0, 7)),
	step("3Bb", giwhole, random:k(0, 7)))
endif

chnset(lfse(1, 9, gkbeatf/64), "witches.mod")

$if	eu(2, 5, 4, "heart") $then
	e("witches",
	gkbeats*8,
	$f,
	step("2Bb", giwhole, pump(16, fillarray(3, 4, 5)+kup)))
endif

	endin
	start("score")

	instr route

getmeout("cascadexp", hlowa(1, gkbeatf))
routemeout("aaron", "shy")
getmeout("witches", hlowa(1, gkbeatf*1.11, .25, 3))

flingue("witches", a(lfse(.005, .025, gkbeatf/18)), lfse(.5, .95, gkbeatf/9), hlowa(1, gkbeatf, 3))

	endin
	start("route")
