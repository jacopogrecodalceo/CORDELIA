	instr score

gkpulse = 135

if (eu(9, 8, 16, "heart") == 1) then
	e("repuck",
	gkbeats*2,
	accent(9, $ff),
	once(fillarray(gieclassic, giclassic)),
	step("5B", giminor3, once(fillarray(1, 2, 7, 3, 7))),
	step("4B", gimjnor, once(fillarray(1, 3, 6, 5, 1, 6))),
	step("5B", giminor, once(fillarray(1, 2, 7, 3, 2, 7))),
	step("5B", gimjnor, once(fillarray(1, 2, 7, 3, 2, 7))))
endif

	endin
	start("score")

	instr route

flingj3("repuck", pump(8, fillarray(5, 3, 5, 1))*25, .25)
flingj3("repuck", pump(12, fillarray(5, 3, 5, 1))*5, .75)
flingj3("repuck", pump(2, fillarray(5, 3, 5, 1))*100, .95)

	endin
	start("route")
