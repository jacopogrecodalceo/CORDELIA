	instr score

gkpulse	= 120

kch	pump 2, fillarray(0, 1, 3, 2)

if (eu(9, 16, 16, "heart") == 1) then
	eva("ixland",
	gkbeats/4,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($fff, $mf)),
	giclassic,
	step("4C", gimajor, pump(1, fillarray(-2, -3, -4, 1))),
	step("4C", gimajor, pump(1, fillarray(1, 1, -2, 4))),
	step("4C", gimajor, pump(2, fillarray(0, 1, 3, 2))))
endif

if (eu(9, 16, 16, "heart") == 1) then
	eva("orphans2",
	gkbeats,
	pump(pump(8, fillarray(32, 48, 16)), fillarray($fff, $p))*4,
	gieclassic$atk(5),
	step("2C", gimajor, pump(1, fillarray(-2, -3, -4, 1))),
	step("3C", gimajor, pump(1, fillarray(1, 1, -2, 4))),
	step("5C", gimajor, pump(2, fillarray(0, 1, 3, 2))))
endif

if (eu(9, 16, 8, "heart") == 1) then
	eva("fairest",
	gkbeats*4,
	pump(pump(8, fillarray(32, 48, 16)), fillarray($fff, $mf))*4,
	gieclassic$atk(5),
	step("1C", gimajor, pump(2, fillarray(0, 1, 3, 2))))
endif

if (eu(12, 16, 15, "heart", 2) == 1) then
	eva("xylo",
	gkbeats,
	accent(4),
	gieclassic$atk(5),
	step("4C", gimajor, pump(1, fillarray(1, 1, -2, 4)))*once(fillarray(.25, .5, 1, 2)))
endif

amen(8, $p)

	endin
	start("score")

	instr route

getmeout("ixland")
getmeout("orphans2")
getmeout("xylo")
getmeout("fairest")

moogj("amen", go(50, 60, 2$k), .5)

	endin
	start("route")

