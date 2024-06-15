	instr score

gkpulse	= 95

$if	eu(3, 12, 16, "heart") $then
	e("haisentitoditom",
	gkbeats*3,
	$f,
	step("3C", gipentamin, pump(27, fillarray(1, 2, 3, 4, 5))),
	step("2D", gipentamin, pump(30, fillarray(1, 2, 3, 4, 5))))
endif
$if	eu(3, 8, 16, "heart", 3) $then
	e("haisentitoditom",
	gkbeats*3,
	$f,
	step("1C", gipentamin, pump(27, fillarray(1, 2, 3, 4, 5))),
	step("3D", gipentamin, pump(30, fillarray(1, 2, 3, 4, 5))))
endif

	endin
	start("score")

	instr route
;routemeout("haisentitoditom", "shy", comeforme(95))
getmeout("haisentitoditom", hlowa(1, gkbeatf, 3)*comeforme(35))
	endin
	start("route")
