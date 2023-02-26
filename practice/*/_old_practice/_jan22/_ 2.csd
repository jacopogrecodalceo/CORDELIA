	instr score

gkpulse	= 120

capriccio1(8, $f)
gesto2(8, $pp)

$if hex("8", 3) $then
	eva("flou",
	gkbeats*8,
	$mp,
	giclassic,
	step("5D", giwhole, 1))
endif

$if hex("8", 2) $then
	eva("flou",
	gkbeats*4,
	$mp,
	gispina,
	step("5D", giquarter, once(fillarray(3, 4, 2, 1, 2))))
endif

gkcapriccio1_dur line 1, 25, .5

	endin
	start("score")

	instr route

shjnot("capriccio1", (gkbeatms*pump(3, fillarray(0, .5, .25, 1)))*pump(16, fillarray(1, .5, .75, 2)), .995)
shj("gesto2", (gkbeatms*pump(3, fillarray(0, .5, .25, 1)))*pump(16, fillarray(1, .5, .75, 2)), .995)
getmeout("flou")
	endin
	start("route")
