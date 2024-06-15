	instr score

gkpulse	= 120

k1	= 1+(2*lfh(2))

$if hex("a9", 16) $then
	eva("etag",
	gkbeats*once(fillarray(k1, .125)),
	accent(4),
	giclassic,
	8)
endif

	endin
	start("score")

	instr route

;distj1("etag", lfh(4))
;distj2("etag", lfh(2)*.5)

k35h("etag", 9$k)

	endin
	start("route")

