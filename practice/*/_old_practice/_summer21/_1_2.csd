	instr score

gkpulse	= 90

if (hex("8881", 8) == 1) then
	eva("mhon2",
	gkbeats,
	$ff,
	once(fillarray(gieclassic, giclassic))$atk(5),
	step("1B", gikumoi, pump(2, fillarray(1, 1, 2, 7))))
endif

if (hex("8881", 12) == 1) then
	eva("puck",
	gkbeats,
	$fff,
	once(fillarray(gieclassic, giclassic))$atk(5),
	step("5B", gikumoi, pump(2, fillarray(1, 1, 2, 7))))
endif

if (hex("1f81", 8) == 1) then
	e("repuck", "qb",
	gkbeats,
	$mp,
	once(fillarray(gieclassic, giclassic))$atk(5),
	step("5D", gikumoi, pump(2, fillarray(1, 1, 2, 7))))
endif
	endin
	start("score")

	
	instr route

getmeout("mhon2")
getmeout("qb")

getmeout("repuck")

shj("mhon2", gkbeatms, .95, .25)
shj("puck", gkbeatms, .5, .85)
	endin
	start("route")

