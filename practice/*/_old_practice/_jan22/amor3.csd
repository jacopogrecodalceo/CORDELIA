	instr score

gkpulse	= 120

kch	pump 2, fillarray(0, 1, 3, 2)

kdur	go 4, 5, 1

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

amen(8, $f)

	endin
	start("score")

	instr route

getmeout("ixland")
getmeout("xylo")
getmeout("fairest")

kvar = 32

flingj("amen", pump(kvar, fillarray(gkbeatms*2, 0, gkbeatms, gkbeatms/4)), oscil:k(1, gkbeatf, gilowasquare))

;flingj("amor", pump(4, fillarray(gkbeatms*2, 0, gkbeatms, gkbeatms/4)), .5)
getmeout("amor")
	endin
	start("route")


if (eu(14, 16, 15, "heart") == 1) then
	eva("amor",
	gkbeats/2,
	accent(4),
	giclassic,
	once(fillarray(.25, .5, 1, 2))*16)
endif
