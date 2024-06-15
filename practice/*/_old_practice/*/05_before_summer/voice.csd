	instr score

gkpulse	= 175 + randomi(-15, 15, gkbeatf/32)

kdur	once fillarray(4, 8, 8, 4)

kdo	pump 2, fillarray(0, -2, -4)
kup	pump 4, fillarray(0, 1, -2, 0, 3, 4, 5)

$if	eu(3, 8, 16, "heart") $then
	e("cascade",
	gkbeats*once(fillarray(4, 4, 4, 0, 0, 0)),
	accent(3, $f),
	once(fillarray(gieclassic, gilikearev, gieclassicr)),
	step("2C", giquarter, once(fillarray(1, 2, 7)+kup)),
	step("0B", gilocrian, once(fillarray(1, 2, 7)), kdo))
endif
$if	eu(3, 8, 16, "heart") $then
	e("alone",
	gkbeats*once(fillarray(4, 4, 4, 0, 0, 0))*3,
	accent(3),
	once(fillarray(gieclassic, gilikearev, gieclassicr)),
	step("5C", giquarter, once(fillarray(1, 2, 7)+kup)),
	step("4B", gilocrian, once(fillarray(1, 2, 7)), kdo))
endif
	endin
	start("score")

	instr route
getmeout("wendj")
powerranger("alone")
getmeout("cascade")
flingue3("fim", oscil:k(125, gkbeatf/lfse(12, 24, gkbeatf/12), gikazan), hlowa(.95, gkbeatf/4))
	endin
	start("route")
