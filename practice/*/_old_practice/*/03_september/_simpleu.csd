	instr Score

gkpulse	= 75

chnset(lfse(1, 9, gkbeatf/8), "supercluster.ndx")

if (eu(9, 24, 16, "heart") == 1) then
	e("supercluster",
	gkbeats/3,
	$fff,
	step("3C", gimajor, pump(32, fillarray(4, 1, 5))))
endif

if (eu(23, 24, 16, "heart") == 1) then
	e("puck",
	gkbeats/4,
	$ff,
	step("4C", gimajor, pump(32, fillarray(1, 4, 5, 6) - 1)),
	step("4C", gimajor, pump(32, fillarray(4, 1, 5, 6) - 2)))
endif

	endin
	start("Score")

	instr Route
getmeout("supercluster")
getmeout("puck")
	endin
	start("Route")
