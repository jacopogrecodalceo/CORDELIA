	instr score

gkpulse = 115

if (eu(4, 16, 16, "heart") == 1) then
	e("repuck", "fim",
	gkbeatf,
	$mf,
	giclassic,
	step("6B", gimjnor, pump(2, fillarray(2, 3, -1, 2))+1),
	step("3C", giwhole, pump(4, fillarray(3, 3, -1, 2))+2),
	step("4C", gimjnor, pump(8, fillarray(3, 3, -1, 2))+2),
	step("5C", giminor3, pump(3, fillarray(1, 3, -1, 2))))
endif

if (eu(4, 16, 16, "heart", 2) == 1) then
	e("puck",
	gkbeatf,
	$mf,
	giclassic,
	step("6B", gimjnor, pump(2, fillarray(2, 3, -1, 2))+1),
	step("3C", giwhole, pump(4, fillarray(3, 3, -1, 2))+2),
	step("4C", gimjnor, pump(8, fillarray(3, 3, -1, 2))+2),
	step("5C", giminor3, pump(3, fillarray(1, 3, -1, 2))))
endif

	endin
	start("score")

	instr route
flingj("repuck", pump(go(2, 75, 3), fillarray(.5, 3, 2, 10))*gkbeats/2, .95)
flingj("puck", pump(go(3, 75, 4), fillarray(.5, 3, 2, 10))*gkbeats/2, .95)
flingj("fim", pump(go(6, 75, 2), fillarray(.5, 5, 2, 10))*gkbeats, .95)
	endin
	start("route")
