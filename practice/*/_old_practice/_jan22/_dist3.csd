	instr score

gkpulse	= 120

k1	= 1+(2*lfh(2))

gknoriff_dur = 1

$if hex("a9", 16) $then
	eva("noriff",
	gkbeats*once(fillarray(k1, 1)),
	accenth(8, $mf),
	gieclassic,
	2, 4)
endif

noriff(1, $p)

	endin
	start("score")

	instr route

distj1("noriff", lfh(4))
;distj2("etag", lfh(2)*.5)

k35h("noriff", ntof("3F")*pump(16, fillarray(.5, .5, 2, 8)), .75)
k35h("noriff", ntof("1F")*pump(12, fillarray(.5, .5, 2, 8))*3/2, .75)

	endin
	start("route")

