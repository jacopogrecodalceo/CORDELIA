	instr score

gkpulse	= 105

k1	= .5

$if	eu(15, 16, 16, "heart") $then
	e("fim",
	gkbeats*pump(24, fillarray(1, .5, 7, 1, .3, 3)),
	$fff*pump(48, fillarray(1, 1, .63)),
	mtof(pump(26, fillarray(61, 54, 58, 53, 61, 53.5, 58.5, 51)-24-k1)),
	mtof(pump(25, fillarray(61, 54, 58, 53, 61, 53.5, 58.75, 51)-12-k1)),
	mtof(pump(24, fillarray(61, 54, 58, 53, 61, 53.25, 58.35, 51)-k1)))
endif

	endin
	start("score")
	instr route
getmeout("fim")
	endin
	start("route")
