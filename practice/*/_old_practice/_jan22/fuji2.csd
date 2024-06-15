	instr score

gkpulse	= 90

kvar	pump 16, fillarray(1, 2)

$if eu(8, 16, 16*kvar, "heart") $then
	eva("fuji",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 2)))/kvar,
	accent(3, $ff, $pp),
	giclassic,
	step("1D", gikumoi, random:k(1, 15)),
	step("4D", gikumoi, random:k(1, 15)))
endif

$if eu(8, 16, 16*kvar, "heart") $then
	eva("repuck",
	gkbeats*once(fillarray(1, .5, 3.5, random:k(.5, 2)))/kvar,
	accent(3, $fff, $p),
	giclassic,
	step("0D", gikumoi, random:k(1, 15)),
	step("3D", gikumoi, random:k(1, 15)))
endif
	endin
	start("score")

	instr route

ringj3("fuji", samphold:k(gkbeatf*lfse(.5, 25, gkbeatf/32), metro(gkbeatf/4)), .95, gilowasine)
ringj3("fuji", samphold:k(gkbeatf*int(lfse(.25, 35, gkbeatf/12)), metro(gkbeatf/8)), .85, gilowasine)

getmeout("repuck")

	endin
	start("route")


