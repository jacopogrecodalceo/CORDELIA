	instr score

gkpulse	= 35 + tempovar(1, 395, gilinear)

ktemp	int 32 - tempovar(1, 31, gilinear)

$if	eu(6, 16, ktemp, "heart", 1) $then
	e("repuck",
	4,
	$mf,
	step("3Ab", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(2, (fillarray(0, -2)))))
endif
$if	eu(3, 16, ktemp, "heart", 2) $then
	e("repuck",
	4,
	$mf,
	step("3Ab", giminor3, pump(12, fillarray(1, 2, 7, 1, 3, 7)), pump(2, (fillarray(0, -2)))))
endif

	endin
	start("score")

	instr route
getmeout("repuck")
	endin
	start("route")
