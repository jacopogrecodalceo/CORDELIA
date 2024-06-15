	instr score

gkpulse	= 130

ift init giwhole
kch pump 8, fillarray(0, -1, 0, 5, 1, 3)

$if hex("888", 32) $then
	eva("repuck",
	gkbeats,
	pump(64, fillarray($ff, $mf, $mf, $mf)),
	giclassic,
	step("3D", ift, 5+pump(4, fillarray(1, 3))),
	step("3D", ift, kch+2+pump(4, fillarray(1, 3, 1, 6))),
	step("1D", ift, kch+0+pump(4, fillarray(1, 3, 1, 6))))
endif

	endin
	start("score")

	

	instr route

getmeout("repuck")
getmeout("noij")

	endin
	start("route")

