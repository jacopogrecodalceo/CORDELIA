	instr score

gkpulse = 95

if (eu(8, 16, 64, "heart") == 1) then
	e("repuck",
	gkbeats*accent(32, 4, .05),
	accent(32, $fff, $ppp),
	once(fillarray(gieclassic, giclassic)),
	step("3C", giminor3, once(fillarray(0, 3, 1, 0, 2)))*accent(32, 2, 1),
	step("3C", gimjnor, once(fillarray(7, 3, 0, 3)))*accent(32, 4, 1))
endif

	endin
	start("score")

	instr route

flingj3("puck", pump(24, fillarray(1, .5, .25, 1))*10, .995)
flingj3("repuck", pump(16, fillarray(1, .5, .25, 1))*10, .995)

	endin
	start("route")
