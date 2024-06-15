	instr score

gkpulse	= 90

kvar	pump 8, fillarray(1, 2, 3)

kmod	pump 4, fillarray(0, 4)

kndx	lfh 4

$if eu(8, 16, 1*kvar, "heart") $then
	eva(oncegen(girot12), "repuck",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 2)))*32,
	accent(3, $fff),
	morpheus(kndx, giclassic, gilikearev)$atk(5),
	step("1D", giminor, random:k(1, 15), kmod),
	step("2D", giminor, random:k(1, 15), kmod),
	step("3D", giminor, random:k(1, 15), kmod),
	step("3D", giminor, random:k(1, 15), kmod),
	step("4D", giminor, random:k(1, 15), kmod))

	gkrpr1 once fillarray(1, 3, 2.5, 1.25, 4, 1)
endif

	endin
	start("score")

	instr route

ringj3("repuck", 3*gkrpr1, .95, gihtri)
ringj3("repuck", 1.5*gkrpr1, .35, gihtri)

	endin
	start("route")
