	instr score

gkpulse	= 150 + go(0, 50, 25)

kndx	lfa 1, gkbeatf/32

$if	eu(3, 8, 32, "heart") $then
	e("fim",
	gkbeats*cunt(.5, 3*32, 2),
	accent(3),
	gieclassic$atk(5),
	step("3D", giquarter, pump(32, fillarray(2, 4, 2, 1)), 0))
endif

ki	pump 8, fillarray(8, 7, 4)
printk2 ki

$if	eu(3, ki, 32, "heart", 1) $then
	e("fim",
	gkbeats*cunt(.5, 3*32, 2),
	accent(4),
	gieclassic$atk(5),
	step("3C", giquarter, pump(32, fillarray(2, 14, 2, 11)), pump(2, fillarray(0, -2, -3, -5))))
endif

	endin
	start("score")

	instr route
getmeout("fim")
	endin
	start("route")
