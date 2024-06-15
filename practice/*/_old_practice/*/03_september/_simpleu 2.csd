	instr Score

gkpulse	= 105

kkk	= pump(2, fillarray(0, 5, 2, -2))

if (eu(4, 4, 8, "heart") == 1) then
	e("wendy",
	gkbeats*3/1.35,
	$fff,
	step("2F#", giminor3, pump(16, fillarray(1, 3) + kkk -2)),
	step("2F#", giminor3, pump(16, fillarray(1, 3) + kkk)),		
	step("3F#", giminor3, pump(16, fillarray(1, 3) + kkk)))
endif
	endin
	start("Score")

	instr Route
getmeout("wendy")
	endin
	start("Route")
