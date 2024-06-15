gkpulse = 125

	start("Score")
	instr Score

kdyn	= .15 + $abslfo(.85'1/beatsk(8))

if (eu(8, 16, circle(8, fillarray(30, 32, 16))) == 1) then
	e("rePuck",
	beatsk(.35),
	scall("2B", gidorian, circle(64, fillarray(1, 5, 8)) + circle(2.5, fillarray(0, 1, -3))),
	$ff*kdyn)
endif

if (eu(8, 16, circle(8, fillarray(30, 32, 16))) == 1) then
	e("Puck",
	beatsk(.15),
	scall("2B", gidorian, circle(64, fillarray(1, 5, 8)) + circle(2.5, fillarray(0, 1, -3))),
	$mp*kdyn)
endif

if (eu(3, 16, 8) == 1) then
	e("rePuck",
	beatsk(3),
	scall("3F#", gidorian, circle(64, fillarray(1, 5, 8)) + circle(2.5, fillarray(0, 1, -3))),
	$ff*kdyn)
endif

	endin



	start("Route")

	instr Route

getmeout("rePuck", .85)
getmeout("Puck", .85)

	endin

