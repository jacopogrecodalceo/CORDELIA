	instr score

gkpulse	= 105
kndx	abs oscil:k(1, gkbeatf/64, gitri)

$if	eu(8, 16, 32, "heart") $then
	e("fim",
	gkbeats/2,
	$f,
	morpheus(kndx, gilikearev, gimirror),
	step("3D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif

	endin
	start("score")

	instr route
getmeout("fim")
	endin
	start("route")
