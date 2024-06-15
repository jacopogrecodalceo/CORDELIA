	instr score

gkpulse = 135

if (eu(4, 16, 4, "heart") == 1) then
	e("repuck", "fim",
	110,
	$pppp,
	-giclassic,
	step("6C", gimjnor, pump(2, fillarray(2, 3, -1, 2))+1),
	step("4C", gimjnor, pump(2, fillarray(3, 3, -1, 2))+2),
	step("5C", giminor3, pump(2, fillarray(1, 3, -1, 2))))
endif

	endin
	start("score")

	instr route
flingj("repuck", pump(goi(16, 75, 8), fillarray(.5, 3, 2, 10))*gkbeats/2, .95)
flingj("puck", pump(12, fillarray(.5, 3, 2, 10))*gkbeats/2, .95)
flingj("fim", pump(32, fillarray(.5, 5, 2, 10))*gkbeats, .995)
	endin
	start("route")
