	instr score

gkpulse	= 90

kch	pump 12, fillarray(7, 6, 4, 5)
klfo	lfh 2
$if eu(7, 8, 24, "heart") $then
	eva("wutang",
	gkbeats*once(fillarray(2, 1, .75)),
	accenth(11, $ff, $mp),
	once(fillarray(gieclassic, giclassic)),
	step("4B", gikal, pump(32, fillarray(1, 2, kch, 1, 2, kch)))*once(fillarray(.25, .5, 1)),
	step("4F#", gikal, pump(8, fillarray(kch, 1, 2, kch))))
endif


$if eu(8, 8, 32, "heart") $then
	eva("ixland",
	gkbeats*once(fillarray(2, 1, .75)),
	accenth(3, $mf*klfo),
	once(fillarray(gieclassic, giclassic)),
	step("3B", gikal, pump(32, fillarray(1, 2, kch, 1, 2, kch)))*once(fillarray(.25, .5, 1)),
	step("3F#", gikal, pump(8, fillarray(kch, 1, 2, kch))))
endif

	endin
	start("score")

	
	instr route

getmeout("wutang")
getmeout("ixland")

	endin
	start("route")

