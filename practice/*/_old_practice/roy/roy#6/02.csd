	instr score

gkpulse	= 70

ift init giwhole
kch pump 8, fillarray(0, -1, 0, 5, 1, 3)

$if hex("888", 4) $then
	eva("noij",
	gkbeats*8,
	pump(64, fillarray($ff, $mf, $mf, $mf))/48,
	giatri,
	step("4B", ift, 5+pump(4, fillarray(1, 3))),
	step("3B", ift, kch+2+pump(4, fillarray(1, 3, 1, 6))),
	step("1B", ift, kch+pump(4, fillarray(1, 3, 1, 6))))
endif

	endin
	start("score")

	

	instr route

getmeout("noij")

	endin
	start("route")

