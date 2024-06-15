	instr score

gkpulse	= 25+go(0, 150, 100)
kndx	lfa 1, gkbeatf/32
kdur	= .5 + lfo(.05, gkbeatf/12, 1)

$if	eu(8, 16, 32, "heart") $then
	e("fim",
	gkbeats*kdur*once(fillarray(.5, 1, 4)),
	accent(3),
	morpheus(kndx, gilikearevr, gieclassic, gimirror),
	step("1F", giquarter, pump(24, fillarray(1, 2, 7, 1, 3, 7, 1, 2))-pump(8, fillarray(0, -2, -8, 2))-pump(1, fillarray(0, -2, -8, 2))),
	step("0D", giquarter, pump(24, fillarray(1, 2, 7, 1, 3, 7, 1, 2))-pump(8, fillarray(0, -2, -8, 2))-pump(1, fillarray(0, -2, -8, 2))))
endif
$if	eu(9, 16, 16, "heart") $then
	e("cascadexp",
	gkbeats*kdur*once(fillarray(1, 2))*7,
	accent(3, $mp, .25),
	morpheus(kndx, gilikearev, gieclassic, gimirror),
	step("0D", giminor3, pump(32, fillarray(1, 2, 7, 1, 3, 7, 1, 2))-pump(8, fillarray(0, -2, -8, 2))-pump(1, fillarray(0, -2, -8, 2))))
endif
$if	eu(7, 16, 12, "heart") $then
	e("ohoh",
	gkbeats*3*kdur,
	$mf,
	gieclassic$atk(5),
	step("3F", gipentamaj, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif
	endin
	start("score")

	instr route
getmeout("cascadexp")
getmeout("ohoh")
getmeout("fim")
getmeout("cascade")
	endin
	start("route")
