	instr score

gkpulse	= 120

kch	pump 2, fillarray(0, 1, 3, 2)

if (eu(12, 16, 15, "heart", 2) == 1) then
	eva("amor",
	gkbeats,
	accent(4),
	gieclassic,
	once(fillarray(.25, .5, 1, 2))*16)
endif

if (eu(12, 16, 9, "heart") == 1) then
	eva("amor",
	gkbeats*2,
	accent(4),
	-gieclassic,
	once(fillarray(.25, .5, 1, 2))*16)
endif


	endin
	start("score")

	instr route

getmeout("ixland")
getmeout("orphans2")
getmeout("xylo")
getmeout("fairest")
getmeout("amor", 4)
moogj("amen", go(50, 60, 5$k), .85)
	endin
	start("route")

