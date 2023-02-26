	instr score

gkpulse	= 65

k1	pump 2, fillarray(2, 0, -4, -5)

katk	= 1/16 + lfa(.5, gkbeatf/16)

$if	eu(3, 16, 4, "heart") $then
	e("witches",
	gkbeats*8,
	accent(3, $pp),
	giclassic,
	step("2F#", gimjnor, once(fillarray(7, 5, 6, 7, 2, 7, 3))+k1),
	step("4F#", giminor3, once(fillarray(2, 3, 5, 4, 3))+k1))	
endif

$if	eu(8, 16, 32, "heart") $then
	e("repuck",
	gkbeats*katk,
	accent(4, $mp),
	giclassic,
	step("1F#", gimjnor, once(fillarray(7, 5, 6, 7, 2, 7, 3))+k1),
	step("3F#", gimjnor, once(fillarray(7, 5, 6, 7, 2, 7, 3))+k1),
	step("4F#", giminor3, once(fillarray(2, 3, 5, 4, 3))+k1))	
endif

	endin
	start("score")

	instr route

folj("witches", "repuck", 50, 5)
getmeout("repuck", lfa(.5, gkbeatf/128))

	endin
	start("route")
