	instr score

gkpulse	= 65

$if	eu(5, 16, 2, "heart") $then
	e("wendj",
	gkbeats*32,
	.005,
	gispina,
	step("1C", giminor3, once(fillarray(0, 1, lfa(4, 10), 7, 3))),
	step("1F", giminor3, once(fillarray(0, 1, lfa(4, 10), 7, 3))),
	step("0B", giminor3, once(fillarray(0, 1, lfa(4, 10), 7, 2))))
endif

	endin
	start("score")

	instr route
getmeout("wendj")
flingue("wendj", goi(105, 105, 1))
;flingue("wendj", 2)
	endin
	start("route")
