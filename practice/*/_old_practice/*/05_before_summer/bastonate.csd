	instr score

gkpulse	= 125
kdur	= 1

$if	eu(5, 16, 8, "heart") $then
	e("detuned",
	gkbeats*kdur,
	accent(4, $ppp),
	once(fillarray(gieclassic, gilikearev, gimirror)),
	step("2D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, 1, 2))-pump(8, fillarray(0, -2, -8, 2))-pump(1, fillarray(0, -2, -8, 2))))
endif

	endin
	start("score")

	instr route
getmeout("detuned")
	endin
	start("route")
