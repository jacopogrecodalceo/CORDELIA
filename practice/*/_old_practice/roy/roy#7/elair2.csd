	instr score

gkpulse = 50

kdyn lfh 2

elair(1, $mf)

;gkgain comeforme 11
;gkgain fadeaway 11

kdur = 1+lfh(1)*8

$when(eujo(3, 8, 4))
	eva("bebor",
	gkbeats*kdur,
	accent(3, $fff),
	giclassic,
	step("4F", giwhole, 2+pump(12, fillarray(2, 3, 2, 7))),
	step("4F", giwhole, pump(6, fillarray(2, 3, 2, 7))),
	step("4F", giwhole, 1))
endif

$when(eujo(5, 8, 16))
	eva("alonefr",
	gkbeats*kdur,
	accent(3, $pp)*$once(0, 1, 1, 0, 0),
	gieclassic,
	step("5F", giwhole, pump(24, fillarray(2, 3, 2, 7))))
endif

$when(eujo(3, 8, 6))
	eva("cascade",
	gkbeats*kdur,
	accent(3, $p),
	gired$atk(5),
	step("5F", giwhole, 2+pump(16, fillarray(2, 3, 2, 7))),
	step("5F", giwhole, pump(8, fillarray(2, 3, 2, 7))),
	step("5F", giwhole, 1))
endif

	endin
	start("score")

	
	instr route

ringhjs("bebor", int(1+lfh(6)*7), .5*lfh(3), gisotrap)
ringhjs("cascade", int(1+lfh(6)*3), .5*lfh(3), giasine, 6)
ringhjs("alonefr", int(1+lfh(6)*3), .5*lfh(3), giasine, 6)

k35h("elair", 5.5$k+(lfh(12)*3.5$k), .5*lfh(9))
k35h("elair", .5$k+(lfh(16)*7.5$k), .25*lfh(24))

k35h("mhon2q", 3.5$k+(lfh(16)*5.5$k), .25*lfh(24))
k35h("alone", .5$k+(lfh(16)*7.5$k), .25*lfh(24))

	endin
	start("route")

