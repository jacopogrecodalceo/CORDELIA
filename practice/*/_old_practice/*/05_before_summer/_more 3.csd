	instr score

gkpulse	= 15

$if	eu(3, 8, 8, "heart") $then
	d("cascade",
	gkbeats*2,
	$p,
	giclassic$atk(55),
	step("3B", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7))+2),
	step("2B", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7))))
endif
$if	eu(3, 8, 8, "heart", 2) $then
	d("cascade",
	gkbeats*2,
	$p,
	giclassic,
	step("2B", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7))))
endif

$if	eu(3, 8, 8, "heart") $then
	d("fim",
	gkbeats*2,
	$mf,
	giclassic$atk(55),
	step("2B", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7))+2),
	step("1B", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7))))
endif
$if	eu(3, 8, 8, "heart", 2) $then
	d("fim",
	gkbeats*2,
	$ff,
	gieclassic,
	step("2B", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7))))
endif

	endin
	start("score")

	instr route
getmeout("cascade")
getmeout("fim")
	endin
	start("route")
