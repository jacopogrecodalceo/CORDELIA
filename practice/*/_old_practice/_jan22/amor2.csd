	instr score

gkpulse	= 120

kch	pump 2, fillarray(0, 1, 3, 2)

kdur	expon 4, 25, 1

if (eu(12, 16, 16, "heart", 2) == 1) then
	eva(oncegen(girot), "amor",
	gkbeats/kdur,
	accent(4),
	gieclassic,
	once(fillarray(.25, .5, 1, 2))*16)
endif

if (eu(12, 16, 16, "heart") == 1) then
	eva(oncegen(-girot), "amor",
	gkbeats/(kdur*2),
	accent(4),
	giclassic,
	once(fillarray(.25, .5, 1, 2))*16)
endif

amen(8, $p)

	endin
	start("score")

	instr route

getmeout("ixland")
getmeout("amen")
getmeout("xylo")
getmeout("fairest")
flingj("amor", pump(4, fillarray(gkbeatms*2, 0, gkbeatms, gkbeatms/4)), .5)
moogj("amen", go(50, 15, 5$k), .85)
	endin
	start("route")


if (eu(14, 16, 15, "heart") == 1) then
	eva("amor",
	gkbeats/2,
	accent(4),
	giclassic,
	once(fillarray(.25, .5, 1, 2))*16)
endif
