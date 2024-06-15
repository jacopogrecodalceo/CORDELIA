	instr score

gkpulse	= 75-timeh(4)

kdur	expseg 8, 35, 1, 95, 2

$if	eu(5, 16, 64, "heart") $then
	e("bee",
	gkbeats*once(fillarray(1, 1, random(1, kdur)/2, .5, .5)),
	accent(5),
	gieclassic$atk(5),
	step("1B", gilocrian, once(fillarray(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 2, 7, 5, 1))))
endif
$if	eu(4, 16, 64, "heart") $then
	e("bee",
	gkbeats*once(fillarray(1, 1, random(1, kdur), .5, .5)),
	accent(5),
	once(fillarray(gieclassic$atk(5), gieclassic$atk(5), gieclassic$atk(5), gieau)),
	step("3G", gipentamin, once(fillarray(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 2, 7, 5, 3))))
endif
$if	eu(7, 16, 64, "heart") $then
	e("bee",
	gkbeats*once(fillarray(1, 1, random(1, kdur)*2, .5, .5)),
	accent(5),
	gieclassic$atk(5),
	step("3E", giquarter, once(fillarray(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 2, 7, 5, 7))))
endif
$if	eu(7, 16, 64, "heart") $then
	e("bee",
	gkbeats*once(fillarray(1, 1, random(1, kdur)*2, .5, .5)),
	accent(5, $p),
	once(fillarray(gieclassic$atk(5), gieclassic$atk(5), gieclassic$atk(5), gieau)),
	step("5E", giquarter, once(fillarray(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 2, 7, 5, 7))*1.5))
endif
$if	eu(5, 16, 64, "heart") $then
	e("click",
	gkbeats/2,
	accent(5, $p),
	gieclassic,
	step("3E", giquarter, once(fillarray(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 2, 7, 5, 7))),
	step("5B", gilocrian, once(fillarray(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 2, 7, 5, 1))))
endif

$if	eu(5, 16, 64, "heart") $then
	e("fim",
	gkbeats/2,
	$pp,
	gieclassic$atk(5),
	step("2B", gilocrian, once(fillarray(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 2, 7, 5, 1))))
endif
	endin
	start("score")

	instr route
getmeout("bee")
getmeout("click")
getmeout("fim")
flingue("bee", lfse(0, 5, gkbeatf/64), .75, lfa(.5, gkbeatf/128))
	endin
	start("route")
