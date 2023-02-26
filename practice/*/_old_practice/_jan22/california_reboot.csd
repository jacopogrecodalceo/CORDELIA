	instr score

gkpulse	= 135

gkwutang_vib = 1

k1	pump 4, fillarray(0, -5)
k2	= 8

katk	lfse 1, 3, gkbeatf/32

$if	eu(8, 16, 32/2, "heart") $then
	eva("wutang",
	gkbeats*katk*once(fillarray(1/2, 1, 4)),
	accent(3),
	gilikearev$atk(1),
	step("4E", giminor3, pump(k2-1, fillarray(1, 2, 7, 1, 3, 7)+4), k1)*once(fillarray(1/4, 1/2, 1)),
	step("4E", giminor3, pump(k2-1, fillarray(1, 2, 7, 1, 3, 7)+1), k1)*once(fillarray(1/4, 1/2, 1)),
	step("4E", giminor3, pump(k2-1, fillarray(1, 2, 7, 1, 3, 7)), k1)*once(fillarray(1/4, 1/2, 1)))
endif

k3	pump 2, fillarray(16, 16, 16, 16, 16, 12, 14, 12)

$if	eu(4, 16, k3*2, "heart", 2) $then
	eva("wutang",
	gkbeats*katk,
	accent(3),
	gilikearev$atk(1),
	step("4E", gimjnor, pump(k2, fillarray(1, 2, 7, 1, 3, 7)), k1)*once(fillarray(1/4, 1/2, 1)),
	step("4E", giminor, pump(k2-3, fillarray(1, 2, 7, 1, 3, 7)), k1)*once(fillarray(1/4, 1/2, 1)))
endif

	endin
	start("score")

	instr route
getmeout("fim")
getmeout("wutang")
getmeout("wendj")
	endin
	start("route")
