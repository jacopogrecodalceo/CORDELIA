	instr score

gkpulse = 135

if (eu(8, 16, 64, "heart") == 1) then
	e("repuck",
	gkbeats*accent(8, 1, $mp),
	accent(8, $fff, $p),
	once(fillarray(gieclassic, giclassicr)),
	step("3D", giminor3, once(fillarray(0, 3, 1, 0, 2))),
	step("3D", gimjnor, once(fillarray(7, 3, 0, 3))))
endif

if (eu(4, 16, 16, "heart") == 1) then
	e("puck",
	gkbeats*8,
	accent(4, $ff),
	once(fillarray(gieclassic, giclassicr)),
	step("3D", giminor3, once(fillarray(0, 3, 1, 0, 2))),
	step("3D", gimjnor, once(fillarray(7, 3, 0, 3))))
endif
	endin
	start("score")

	instr route

flingj3("puck", pump(24, fillarray(1, .5, .25, 1))*10, .995)
flingj3("repuck", pump(16, fillarray(1, .5, .25, 1))*10, .995)

	endin
	start("route")
