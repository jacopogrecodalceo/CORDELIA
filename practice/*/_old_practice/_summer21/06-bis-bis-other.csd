	instr score

gkpulse	= 35

$if	eu(3, 16, 12, "heart") $then
	e("orphans2",
	gkbeats*8,
	accent(3, $fff),
	gieclassic,
	step("3A#", giminor3, once(fillarray(1, 5, 7, 3))),
	step("3A#", giminor3, once(fillarray(2, 3, 5, 4))))	
endif

$if	eu(3, 16, 12, "heart") $then
	e("cascade",
	gkbeats*8,
	accent(3, $p),
	gieclassic,
	step("2A#", giminor3, once(fillarray(1, 5, 7, 3))),
	step("4A#", giminor3, once(fillarray(2, 3, 5, 4))))	
endif


$if	eu(3, 16, 16, "heart") $then
	e("orphans",
	gkbeats,
	accent(3, $pp),
	gieclassic,
	step("4A#", giminor3, once(fillarray(2, 3, 5, 4))))	
endif

$if	eu(3, 16, 16, "heart", 2) $then
	e("orphans",
	gkbeats,
	accent(3, $pp),
	gieclassic,
	step("4A#", giminor3, once(fillarray(1, 5, 7, 3))))
endif



$if	eu(3, 16, 24, "heart") $then
	e("orphans2",
	gkbeats,
	accent(3, $p),
	gieclassic,
	step("5A#", giminor3, once(fillarray(2, 3, 5, 4, 2, 3, 4, 5))))	
endif

$if	eu(3, 16, 24, "heart", 2) $then
	e("orphans2",
	gkbeats,
	accent(3, $p),
	gieclassic,
	step("5A#", giminor3, once(fillarray(1, 5, 7, 3, 1, 5, 6, 2))))
endif

	endin
	start("score")

	instr route

getmeout("orphans2")
getmeout("orphans")
getmeout("cascade")	

	endin
	start("route")
