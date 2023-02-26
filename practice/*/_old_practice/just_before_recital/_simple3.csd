	instr score

gkpulse	= 90

kch	pump 12, fillarray(7, 6, 4, 5)


$if eu(5, 8, 32, "heart") $then
	eva("bleu",
	gkbeats*once(fillarray(1.5, 0, 0, 0)),
	accenth(4, $fff),
	once(fillarray(gieclassicr, giclassic, gilikearev)),
	2,
	step("2F#", gikal, pump(32, fillarray(kch, 1, 2, kch)))*once(fillarray(2, .25, .125, 1)))
endif

$if eu(5, 8, 16, "heart") $then
	eva("bass",
	gkbeats*once(fillarray(1.5, 0, 0, 2)),
	accenth(4, $fff),
	once(fillarray(gieclassicr, giclassic, gilikearev)),
	step("0F#", gikal, pump(32, fillarray(kch, 1, 2, kch)))*once(fillarray(2, .25, .125, 1)))
endif

	endin
	start("score")

	
	instr route

flingj("bleu", gkbeatms, .5)
getmeout("wutang")
getmeout("cascade")
getmeout("bass")

	endin
	start("route")

