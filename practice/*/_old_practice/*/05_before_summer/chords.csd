	instr score

gkpulse	= 120

kn3	pump 4, fillarray(8, 8, 7, 5)

karr[]	init 3
karr	fillarray 1, 3, kn3

k1	pump 2, fillarray(0, -2, -4, -5)
k2	pump 2, fillarray(0, -2, -4)
k3	pump 16, fillarray(0, 0, 2, 0, 0, 0, 0, 0)

$if	eu(8, 16, 32, "heart", 1) $then
	e("fim",
	gkbeats/once(fillarray(4, 4, 2)),
	accent(4),
	once(fillarray(giclassic, giclassic, gieclassic)),
	step("2A", gikumoi, once(karr), k1),
	step("4C", giwhole, once(karr), k2),
	step("4E", gilocrian, once(karr), k3))
endif

	endin
	start("score")

	instr route
getmeout("fim")
	endin
	start("route")
