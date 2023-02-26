	instr score

gkpulse	= 120

$if hex("f18", 16) $then
	gkfalga_sonvs once fillarray(1, random:k(1, 25), 11, 9, 5, 3, 2)
endif

falga(6, $mp)
falga(9, $mp)

	endin
	start("score")

	instr route

getmeout("falga")

	endin
	start("route")

