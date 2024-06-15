	instr score

gkpulse	= 120-timeh(4)

k1	= 1+(2*lfh(2))

$if hex("a9a9a9a0", 8) $then
	eva("armagain",
	gkbeats*pump(16, fillarray(8, .125, 4, .35)),
	accent(4, $ff, $pp),
	giclassic,
	$once(8, 14, 12, 4, 2))

	valle(8, $f)
endif

	endin
	start("score")

	instr route

ringhj3("armagain", pump(16, fillarray(1, 2, 4)), lfh(1), gikazan)
ringhj("amen", pump(8, fillarray(1, .5, 1, .65)), lfh(2), giasquare)
distj2("valle", 1)
k35h("mario1", pump(32, fillarray(2, 4, 6, 8, 1, .5))$k, .35)
k35h("armagain", pump(8, fillarray(2, 4, 6, 8, 1, .5))$k, .35)

	endin
	start("route")

