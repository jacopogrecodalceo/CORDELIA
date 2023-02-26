	instr score

gkpulse	= 90

kvar	pump 16, fillarray(1, 2)

$if eu(8, 16, 4*kvar, "heart") $then
	eva(oncegen(girot), "aaron",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 2)))*4,
	accent(3, $f, $ppp),
	giclassic$atk(5),
	step("3D", gikumoi, random:k(1, 15)),
	step("4D", gikumoi, random:k(1, 15)))
endif

	endin
	start("score")

	instr route

ringj3("aaron", samphold:k(gkbeatf*lfse(.25, 5, gkbeatf/32), metro(gkbeatf)), .95, gilikearev)
ringj3("aaron", samphold:k(gkbeatf*lfse(.5, 5, gkbeatf/32), metro(gkbeatf/2)), .95, gilikearevr)

	endin
	start("route")


