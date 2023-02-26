	instr score

gkpulse	= 105

krel	lfse .25, 16, gkbeatf/16

$if	eu(9, 16, 32, "heart") $then
	e("puck",
	gkbeats*krel,
	$fff,
	step("3Ab", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(2, (fillarray(0, -2)))))
endif

	endin
	start("score")

	instr route
routemeout("puck", "shy")
	endin
	start("route")
