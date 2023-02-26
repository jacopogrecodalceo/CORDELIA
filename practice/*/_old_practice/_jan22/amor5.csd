	instr score

gkpulse	= 60*int(randomh(1, 3, .5))

kch	pump 2, fillarray(0, 1, 3, 2)

kdur	go 4, 25, 1

if (eu(12, 16, 16, "heart", 2) == 1) then
	eva(oncegen(girot), "amor",
	gkbeats/kdur,
	accent(4),
	gieclassic,
	once(fillarray(.25, once(fillarray(.5, .75, 2.5, 3)), 1, 2))*16)
endif

if (eu(12, 16, 16, "heart") == 1) then
	eva(oncegen(-girot), "amor",
	gkbeats/(kdur*2),
	accent(4),
	giclassic,
	once(fillarray(.25, .5, 1, 2))*16)
endif

madcow(pump(8, fillarray(32, 8, 16)), $mf)

gkmadcow_dur = pump(4, fillarray(1, .5, .75, 1))

	endin
	start("score")

	instr route

getmeout("ixland")
getmeout("xylo")

kvar = 32

flingj("madcow", pump(kvar, fillarray(gkbeatms*2, 0, gkbeatms, gkbeatms/4)), oscil:k(1, gkbeatf*4, gilowasquare))

;flingj("amor", pump(4, fillarray(gkbeatms*2, 0, gkbeatms, gkbeatms/4)), .5)
getmeout("amor", 8)
	endin
	start("route")


if (eu(14, 16, 15, "heart") == 1) then
	eva("amor",
	gkbeats/2,
	accent(4),
	giclassic,
	once(fillarray(.25, .5, 1, 2))*16)
endif
