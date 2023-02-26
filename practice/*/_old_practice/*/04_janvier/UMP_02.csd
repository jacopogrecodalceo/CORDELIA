	instr score

gkpulse	= 135

kran	= 8*floor(random:k(0, 1))

$if	eu(3, 8, 16, "heart") $then
	e("wendy",
	gkbeats*2,
	$f,
	step("3B", gidorian, pump(16, fillarray(7, 7, 5, 4, 1, 5, 3, 1)+kran)))
endif
$if	eu(3, 8, 16, "heart") $then
	e("wendy",
	gkbeats,
	$mf,
	step("2B", gidorian, pump(32, fillarray(7, 7, 5, 4, 1, 5, 3, 1))))
endif
$if	eu(3, 8, 32, "heart", 1) $then
	e("wendy",
	gkbeats,
	$f,
	step("1B", gidorian, pump(8, fillarray(7, 7, 5, 4, 1, 5, 3, 1)+kran)))
endif

$if	eu(7, 8, 32, "heart") $then
	e("supercluster",
	gkbeats*random:k(.5, 3),
	$ff,
	step("0B", gidorian, pump(8, fillarray(7, 7, 5, 4, 1, 5, 3, 1))),
	step("1B", gidorian, pump(8, fillarray(7, 7, 5, 4, 1, 5, 3, 1))))
endif
$if	eu(7, 8, 32, "heart", 1) $then
	e("wingsup",
	gkbeats*random:k(.5, 1),
	$f,
	step("3F#", gimajor, pump(16, fillarray(7, 7, 5, 4, 1, 5, 3, 1))),
	step("0B", gidorian, pump(8, fillarray(7, 7, 5, 4, 1, 5, 3, 1))),
	step("1B", gidorian, pump(8, fillarray(7, 7, 5, 4, 1, 5, 3, 1))))
endif


$if	eu(7, 8, 32, "heart") $then
	e("puck",
	gkbeats,
	$ff,
	step("5B", gidorian, pump(9, fillarray(7, 7, 5, 4, 1, 5, 3, 1))))
endif
$if	eu(7, 8, 32, "heart") $then
	e("repuck",
	gkbeats,
	$ff,
	step("5B", gidorian, pump(9, fillarray(7, 7, 5, 4, 1, 5, 3, 1))))
endif

	endin
	start("score")

	instr route
getmeout("wendy")
getmeout("supercluster")
getmeout("aaron")
getmeout("repuck")

getmeout("wingsup")
flingue("puck", a(lfse(.005, .15, gkbeatf/16)), .75)
	endin
	start("route")
