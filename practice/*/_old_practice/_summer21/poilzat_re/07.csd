	instr score

gkpulse	= 65

k1	pump 2, fillarray(2, 0, -4, -5)

$if	eu(10, 16, 16, "heart") $then
	d("cascade",
	gkbeats/4,
	accent(5, $fff, $p),
	giclassic,
	step("4F#", gimjnor, once(fillarray(5, 6, 7, 2, 7, 3))+k1),
	step("4F#", gimjnor, once(fillarray(7, 5, 7, 2, 7, 3))+k1),
	step("3F#", gimjnor, once(fillarray(7, 5, 6, 7, 2, 7, 3))+k1),
	step("3F#", giminor3, once(fillarray(2, 3, 5, 4, 3))+k1))	
endif

	endin
	start("score")

	instr route
flingj("cascadexp", randomi:k(gkbeats/16, gkbeats, gkbeatf/8), randomi:k(.5, .995, gkbeatf))

flingj("cascade", randomi:k(gkbeats/16, gkbeats/32, gkbeatf/8), randomi:k(.5, .995, gkbeatf))
	endin
	start("route")
