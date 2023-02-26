	instr score

gkpulse	= 105

katk	lfse 1, 95, gkbeatf/8

ktog	pump	12, fillarray(4, 19, 15, 18, 16)

$if	eu(9, 16, ktog, "heart") $then
	e("cascadexp",
	gkbeats*2,
	$mf,
	gilikearev$atk(katk),
	step("3D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif
$if	eu(8, 16, 32, "heart", 1) $then
	e("click",
	gkbeats*once(fillarray(1, 2, .5, .5, .5, .5, .5, .5)),
	$mf,
	gieclassic,
	step("4D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))))
endif
$if	eu(8, 16, 32, "heart") $then
	e("ipercluster",
	gkbeats/random(.5, 2),
	$mf,
	once(fillarray(gieclassic, gimirror)),
	step("3D", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -12)))))
endif

$if	eu(3, 16, 8, "heart") $then
	e("cascade",
	gkbeats*3,
	$f,
	-gieclassic$atk(5),
	step("2F", gipentamaj, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif

$if	eu(9, 16, ktog, "heart", 1) $then
	e("cascadexp",
	gkbeats*2,
	$mf,
	gilikearev$atk(katk),
	step("3F", gipentamaj, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif

	endin
	start("score")

	instr route
getmeout("cascadexp")
getmeout("click", comeforme(15))
moog("ipercluster", lfse(2500, 3500, gkbeatf/24), lfse(.25, .85, gkbeatf/8))
flingue("cascade", lfse(.05, .015, gkbeatf/64), .95)
	endin
	start("route")
