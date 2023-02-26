	instr score

gkpulse	= 90

kvar	pump 16, fillarray(1, 2)

kmod	pump 4, fillarray(0, 4)

kndx	lfh 4

$if eu(8, 16, 1*kvar, "heart") $then
	eva("repuck",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 2)))*24,
	accent(3, $ff),
	morpheus(kndx, giclassic, gilikearev)$atk(5),
	step("1D", giminor, random:k(1, 15), kmod),
	step("2D", giminor, random:k(1, 15), kmod),
	step("3D", giminor, random:k(1, 15), kmod),
	step("3D", giminor, random:k(1, 15), kmod),
	step("4D", giminor, random:k(1, 15), kmod))
endif

	endin
	start("score")

	instr route

ringhj3("repuck", 3, .95, gilowatri)
ringhj3("repuck", 1.5, .35, gilowatri)
pitchj("repuck", 1+lfh(8, gieclassicr), .25)

	endin
	start("route")
