	instr score

gkpulse	= 70

ift init gipentamin
kch pump 8, fillarray(0, -1, 0, 5, 1, 3)

$if hex("8", 3) $then
	eva("noij",
	gkbeats*8,
	pump(64, fillarray($ff, $mf, $mf, $mf))/64,
	giatri,
	step("4Eb", ift, 5+pump(4, fillarray(1, 3))),
	step("3C", ift, kch+2+pump(4, fillarray(1, 3, 1, 6))),
	step("1G", ift, kch+pump(4, fillarray(1, 3, 1, 6))))
endif

	endin
	start("score")

	

	instr route

getmeout("noij")
getmeout("mhon2q")

	endin
	start("route")

