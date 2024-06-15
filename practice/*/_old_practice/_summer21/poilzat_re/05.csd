	instr score

gkpulse = 135

if (eu(4, 16, 32, "heart") == 1) then
	e("repuck", "puck",
	gkbeats*accent(8, 8, .25),
	accent(8, $fff, $pp),
	giclassic,
	step("4C", gimjnor, pump(2, fillarray(1, 3, -1, 2))+1),
	step("4C", gimjnor, pump(2, fillarray(1, 3, -1, 2))+2),
	step("4C", giminor3, pump(2, fillarray(1, 3, -1, 2))))
endif

	endin
	start("score")

	instr route
flingj("repuck", pump(16, fillarray(.5, 5, 2, 10))*gkbeats, .995)
flingj("puck", pump(32, fillarray(.5, 5, 2, 10))*gkbeats, .995)
flingj("puck", pump(32, fillarray(.5, 5, 2, 10))*gkbeats, .995)
	endin
	start("route")
