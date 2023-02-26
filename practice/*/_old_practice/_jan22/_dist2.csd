	instr score

gkpulse	= 125

k1	= .125+(2*lfh(2))

$if hex("a9a9a9a8", 16) $then
	eva("etag",
	gkbeats*once(fillarray(k1, .125)),
	accent(4),
	giclassic,
	8, 12)
endif

	endin
	start("score")

	instr route

distj1("etag", lfh(4), lfh(3)*.25)
distj2("etag", lfh(2)*.5, lfh(1)*.25)

kch	pump 4, fillarray(6, 7, 4, 3)
knote	pump 2, fillarray(64, 48, 24, 16)
ktone	pump 1, fillarray(0, -3, 5, 7)

k35h("etag", step("4D", giminor3, pump(knote, fillarray(1, 2, 5-ktone, kch)), ktone)*pump(32, fillarray(.5, 1, 2)), .85, 2)

	endin
	start("route")

