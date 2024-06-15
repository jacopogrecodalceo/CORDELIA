	instr score

gkpulse	= 65

k1	pump 2, fillarray(2, 0, -4, -5)

katk	= 1/16 + lfa(.5, gkbeatf/16)

$if	eu(3, 16, 4, "heart") $then
	e("cascade",
	gkbeats*16,
	accent(3, $fff),
	giclassic,
	step("2F#", gimjnor, once(fillarray(7, 5, 6, 7, 2, 7, 3))+k1),
	step("4F#", giminor3, once(fillarray(2, 3, 5, 4, 3))+k1))	
endif

$if	eu(8, 16, 32, "heart") $then
	e("puck",
	gkbeats*katk,
	accent(4, $ppp),
	giclassic,
	step("2F#", gimjnor, once(fillarray(7, 5, 6, 7, 2, 7, 3))+k1),
	step("3F#", giminor3, once(fillarray(2, 3, 5, 4, 3))+k1))	
endif

$if	eu(5, 16, 48, "heart", 1) $then
	e("puck", "cascade", 
	gkbeats*katk,
	accent(4, $mf),
	giclassic,
	step("5F#", gimjnor, once(fillarray(7, 5, 6, 7, 2, 7, 3))+k1),
	step("5F#", giminor3, once(fillarray(2, 3, 5, 4, 3))+k1))	
endif

	endin
	start("score")

	instr route

folj("cascade", "puck", 50, 50, 2)
getmeout("puck", lfa(.5, gkbeatf/32))

	endin
	start("route")
