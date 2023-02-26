	instr score

gkpulse	= 175 + randomi(-15, 15, gkbeatf/32)

kdur	once fillarray(4, 8, 8, 4)

$if	eu(3, 8, 16, "heart") $then
	e("wendj",
	gkbeats/kdur,
	accent(3),
	giclassic,
	step("3B", giquarter, pump(32, fillarray(3, 7, 5, 4, 1, 5, 3, 1)))*once(fillarray(1, .5, .25, .15)))
endif

$if	eu(3, 8, 12*2, "heart", 1) $then
	e("fim",
	gkbeats/kdur*once(fillarray(2, 2, 3, 4)),
	accent(3),
	giemirror,
	step("2C", giquarter, pump(32, fillarray(3, 7, 5, 4, 1, 5, 3, 1)))*once(fillarray(1, .5, 3, 2)),
	step("4B", giquarter, pump(32, fillarray(3, 7, 5, 4, 1, 5, 3, 1)))*once(fillarray(1, .5, 3, 2)))
endif

kdo	pump 2, fillarray(0, -2, -4)
kup	pump 4, fillarray(0, 1, -2, 0, 3, 4, 5)

$if	eu(3, 8, 16, "heart") $then
	e("cascadexp",
	gkbeats*once(fillarray(4, 4, 4, 0, 0, 0)),
	accent(3),
	once(fillarray(gieclassic, gilikearev, gieclassicr)),
	step("5C", giquarter, once(fillarray(1, 2, 7)+kup)),
	step("4B", gilocrian, once(fillarray(1, 2, 7)), kdo))
endif
$if	eu(3, 8, 16, "heart", 2) $then
	e("alone",
	gkbeats*once(fillarray(4, 4, 4, 0, 0, 0))*2,
	accent(3),
	once(fillarray(gieclassic, gilikearev, gieclassicr)),
	step("5C", giquarter, once(fillarray(1, 2, 7)+kup)),
	step("4B", gilocrian, once(fillarray(1, 2, 7)), kdo))
endif
	endin
	start("score")

	instr route
getmeout("wendj")
;powerranger("alone", .05)
;getmeout("cascadexp")
;flingue3("fim", oscil:k(125, gkbeatf/lfse(12, 24, gkbeatf/12), gikazan), hlowa(.95, gkbeatf/4))
	endin
	start("route")
