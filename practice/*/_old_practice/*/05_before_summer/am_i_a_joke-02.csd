	instr score

gkpulse	= 125
kndx	lfa 1, gkbeatf/16
kdur	= .5 + lfo(.05, gkbeatf/32, 1)

$if	eu(8, 16, 32, "heart") $then
	e("fim",
	gkbeats*kdur*once(fillarray(.5, 1, 2)),
	accent(3),
	morpheus(kndx, gilikearev, gieclassic, gimirror),
	step("2D", giquarter, pump(32, fillarray(1, 2, 7, 1, 3, 7, 1, 2))-pump(8, fillarray(0, -2, -8, 2))-pump(1, fillarray(0, -2, -8, 2))))
endif
$if	eu(6, 16, 16, "heart") $then
	e("cascadexp",
	gkbeats*kdur*once(fillarray(1, 2))*7,
	accent(3, $mp, .25),
	morpheus(kndx, gilikearev, gieclassic, gimirror),
	step("4D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, 1, 2))-pump(8, fillarray(0, -2, -8, 2))-pump(1, fillarray(0, -2, -8, 2))))
endif
$if	eu(3, 16, 8, "heart") $then
	e("cascade",
	gkbeats*3*kdur,
	$mp,
	once(fillarray(-gieclassic$atk(5), giclassic$atk(125))),
	step("2F", gipentamaj, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif

	endin
	start("score")

	instr route
getmeout("cascadexp")
flingue("fim", go(0, 95, .015), go(.5, 95, .75))
flingue("cascade", lfse(.05, .015, gkbeatf/64), .95*comeforme(35))
	endin
	start("route")
