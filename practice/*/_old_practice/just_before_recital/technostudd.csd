	instr score

gkpulse	= 120

k1	go .5, 25, 1

$if hex("a9", 16) $then
	eva("drumhigh",
	gkbeats*once(fillarray(k1, .125)),
	accent(4),
	gieclassic,
	4, 8, 16)
endif

drumhigh(12, $mp)

gkdrumhigh_dur pump 16, fillarray(.25, .5, 1)

	endin
	start("score")

	instr route

distj1("drumhigh", lfh(4))
distj2("drumhigh", lfh(2)*.5)

flingj("drumhigh", gkbeatms, .85, lfh(1))

	endin
	start("route")

