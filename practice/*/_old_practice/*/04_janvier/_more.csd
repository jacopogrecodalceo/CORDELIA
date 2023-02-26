	instr score

gkpulse	= 105

$if	eu(5, 16, 16, "heart") $then
	e("aaron",
	gkbeats/2,
	$f,
	step("4Ab", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7))))
endif

kstep	= pump(8, fillarray(0, 2))

$if	eu(5, 16, 16, "heart") $then
	e("aaron",
	gkbeats/2,
	$mp,
	step("4Ab", giminor3, pump(32, fillarray(5, 5, 0, 5, 5, 0)), kstep-12),
	step("4Ab", giminor3, pump(48, fillarray(5, 5, 0, 5, 5, 0)), kstep))
endif

	endin
	start("score")
	instr route
getmeout("aaron")
	endin
	start("route")
