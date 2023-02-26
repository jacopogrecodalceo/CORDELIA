	instr score

gkpulse	= 120

k1	= 1+(2*lfh(2))

$if hex("a9", 16) $then
	eva("tricot",
	gkbeats*once(fillarray(k1, .25)),
	accenth(8, $mf),
	gieclassic,
	once(fillarray(1, 3, 2, 4, 6, 2, 3)))
endif

$if hex("a92", 16) $then
	eva("tricot",
	gkbeats*once(fillarray(k1/2, .125)),
	accenth(8, $f),
	gieclassic,
	once(fillarray(1, 3, 2, 4, 6, 2, 3)))
endif

	endin
	start("score")

	instr route

k35h("tricot", ntof("3F")*pump(16, fillarray(.5, .5, 2, 8)), .75)
k35h("tricot", ntof("1F")*pump(12, fillarray(.5, .5, 2, 8)), .85)

	endin
	start("route")

