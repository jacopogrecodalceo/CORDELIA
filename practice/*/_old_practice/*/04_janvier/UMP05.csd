	instr score

gkpulse	= 135

kran	= 8*floor(random:k(-2, 2))

$if	eu(9, 16, 16, "heart") $then
	e("puck",
	gkbeats*abs(kran/2),
	$f,
	step("3B", gidorian, pump(16, fillarray(7, 7, 5, 4, 1, 5, 3, 1)+kran)))
endif

$if	eu(9, 16, 16, "heart", 2) $then
	e("puck",
	gkbeats*abs(kran/8),
	$mf,
	step("2B", gidorian, pump(16, fillarray(7, 7, 5, 4, 1, 5, 3, 1)+kran)))
endif

$if	eu(9, 16, 16, "heart", 5) $then
	e("puck",
	gkbeats*abs(kran/4),
	$mf,
	step("2F#", gidorian, pump(16, fillarray(7, 7, 5, 4, 1, 5, 3, 1)+kran)))
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
