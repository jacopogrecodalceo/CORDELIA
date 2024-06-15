	instr score

gkpulse	= 90

if (hex("8081", 4) == 1) then
	eva("witches",
	gkbeats*16,
	$mp,
	once(fillarray(gieclassic, giclassic)),
	step("1B", gikumoi, pump(2, fillarray(1, 1, 2, 7))))
endif
if (hex("8781", 4) == 1) then
	eva("repuck",
	gkbeats*16,
	$mp,
	once(fillarray(gieclassic, giclassic)),
	step("2B", gikumoi, pump(2, fillarray(1, 1, 2, 7))))
endif
if (hex("0a81", 4) == 1) then
	eva("wendj",
	gkbeats*16,
	$pppp,
	once(fillarray(gieclassic, giclassic)),
	step("3B", gikumoi, pump(2, fillarray(1, 1, 2, 7))))
endif
	endin
	start("score")

	
	instr route

getmech("witches", phasor:k(0.15))
getmech("repuck", phasor:k(0.45))
getmech("wendj", phasor:k(0.35))

	endin
	start("route")

