girall	ftgen 0, 0, 16385, 5, .00015, 14500, .15, 1500, 1, 385, 1
giacc	ftgen 0, 0, 16385, 5, 1, 1500, .15, 1, 14500, .00015

	instr score

kphasor	= ((chnget:k("heart")*8)%1)*16384
krall	= tab(kphasor, girall)*115
printk .15, krall

gkpulse	= 135 - (krall*comeforme(45))


kran	= 8*floor(random:k(0, 1))

$if	eu(3, 8, 16, "heart") $then
	e("wendy",
	gkbeats*1.5,
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

$if	eu(5, 8, 32, "heart") $then
	e("haisentitoditom",
	gkbeats*4,
	$fff,
	step("0B", gidorian, pump(8, fillarray(7, 7, 5, 4, 1, 5, 3, 1)+kran)))
endif

$if	eu(3, 8, 32, "heart") $then
	e("supercluster",
	gkbeats,
	$f,
	step("2B", gidorian, pump(8, fillarray(7, 7, 5, 4, 1, 5, 3, 1))),
	step("1B", gidorian, pump(8, fillarray(7, 7, 5, 4, 1, 5, 3, 1))))
endif

$if	eu(5, 8, 4, "heart") $then
	e("aaron",
	gkbeats*4,
	$f,
	step("4B", gidorian, pump(6, fillarray(7, 7, 5, 4, 1, 5, 3, 1)+kran)))
endif

$if	eu(7, 8, 32, "heart") $then
	e("puck",
	gkbeats,
	$ff,
	step("5B", gidorian, pump(9, fillarray(7, 7, 5, 4, 1, 5, 3, 1))))
endif
$if	eu(3, 8, 32, "heart") $then
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
getmeout("haisentitoditom")
flingue("puck", a(lfse(.005, .15, gkbeatf/16)), .75)
	endin
	start("route")
