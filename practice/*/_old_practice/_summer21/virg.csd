	instr score

gkpulse	= 120

if (hex("8881", 8) == 1) then
	eva(oncegen(girot), "fim",
	gkbeats*4,
	$mf,
	once(fillarray(gieclassic, giclassic)),
	step("2B", gikumoi, 1+pump(4, fillarray(3, 2, 2, 5))),
	step("2B", gikumoi, pump(4, fillarray(1, 1, 2, 5))))
endif

if (hex("81fa", 3) == 1) then
	eva(oncegen(girot), "fim",
	gkbeats*8,
	$ff,
	once(fillarray(gieclassic, gispina)),
	step("1B", gikumoi, 1+pump(4, fillarray(3, 2, 2, 5))),
	step("3B", gikumoi, pump(4, fillarray(1, 1, 2, 5))))
endif

	endin
	start("score")

	instr route

flingj("fim", (gkbeatms+pump(3, fillarray(0, .5, .25, 1)))*pump(16, fillarray(1, .5, .75, 2)), .995)

getmeout("amen")
	endin
	start("route")
