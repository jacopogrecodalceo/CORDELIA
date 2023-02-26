	instr score

gkpulse	= 90

kvar	pump 16, fillarray(1, 2)

kmod	pump 4, fillarray(0, 4)

kndx	lfh 4

$if eu(8, 16, 1*kvar, "heart") $then
	eva("wutang",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 2)))*24,
	accent(3, $f),
	gieclassic,
	step("3D", giminor, random:k(1, 15), kmod),
	step("4D", giminor, random:k(1, 15), kmod))
endif

	endin
	start("score")

	instr route

getmeout("wutang")
pitchj("wutang", 2+lfh(8, gieclassicr), .85, 12, gitri, .25)
pitchj("wutang", 2+lfh(4, giclassicr), .95, 12, gisine, .25)
pitchj("wutang", 4-lfh(2, giclassicr), .95, 12, gisquare, .25)

	endin
	start("route")
