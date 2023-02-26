	instr score

gkpulse	= 35

k1	pump 2, fillarray(2, 0, -4, -5)

$if	eu(3, 16, 4, "heart") $then
	e("cascade",
	gkbeats*8,
	accent(3, $mf),
	gieclassic,
	step("0F#", gimjnor, once(fillarray(3, 5, 6, 7, 2, 7, 3))+k1+1),
	step("3F#", gimjnor, once(fillarray(7, 5, 6, 7, 2, 7, 3))+k1-2),
	step("5F#", gimjnor, once(fillarray(7, 5, 6, 7, 2, 7, 3))+k1),
	step("4F#", giminor3, once(fillarray(2, 3, 5, 4, 3))+k1))	
endif

	endin
	start("score")

	instr route

flingj3("cascade", randomi:k(gkbeats/8, gkbeats/4, gkbeatf/8), .95)
flingj3("cascade", randomi:k(gkbeats/16, gkbeats/12, gkbeatf/3), .95)

	endin
	start("route")
