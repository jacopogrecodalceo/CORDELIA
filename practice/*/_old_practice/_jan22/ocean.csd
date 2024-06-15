	instr score

kvar	samphold random:k(0, 50), metro:k(gkbeatf)
printk2 kvar
gkpulse	= 60-kvar

kch	pump 2, fillarray(0, 1, 3, 2)

kdur	go 32, 125, .125

if (eu(3, 16, 8, "heart", 2) == 1) then
	eva("ocean",
	gkbeats*kdur,
	accent(4),
	giclassic,
	once(fillarray(.25, .5, 1, 2))*4)
endif

if (eu(5, 16, 8, "heart") == 1) then
	e("gesto2", "gesto3",
	gkbeats*kdur,
	accent(4),
	giclassic,
	once(fillarray(.25, .5, 1, 2))*8)
endif

	endin
	start("score")

	instr route

getmeout("ixland")
getmeout("xylo")
getmeout("gesto3")
flingj2("ocean", pump(3, fillarray(gkbeatms/2, 0, gkbeatms, gkbeatms/4)), .5)
flingj3("gesto2", pump(6, fillarray(gkbeatms/2, 0, gkbeatms, gkbeatms/4)), .5)

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
