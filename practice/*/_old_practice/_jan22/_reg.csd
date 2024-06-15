	instr score

gkpulse	= 120

reg(2, $mf)
reg(pump(6, fillarray(1, 4, 1, 8)), $pp)

gkreg_off = 900
gkreg_dur = pump(16, fillarray(.5, .25, 1, 2))

	endin
	start("score")

	instr route

getmeout("reg")
	endin
	start("route")
