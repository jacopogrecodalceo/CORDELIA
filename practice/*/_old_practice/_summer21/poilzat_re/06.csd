	instr score

gkpulse	= 65

k1	pump 2, fillarray(2, 0, -4, -5)

$if	eu(3, 16, 4, "heart") $then
	e("cascade",
	gkbeats*16,
	accent(3, $pppp),
	giclassic,
	step("2F#", gimjnor, once(fillarray(7, 5, 6, 7, 2, 7, 3))+k1),
	step("4F#", giminor3, once(fillarray(2, 3, 5, 4, 3))+k1))	
endif

	endin
	start("score")

	instr route

flingj("cascade", randomi:k(gkbeats/8, gkbeats, .5), randomi:k(.5, .995, .5))

	endin
	start("route")
