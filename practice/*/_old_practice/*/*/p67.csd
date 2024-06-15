gkpulse = 75

	start("Score")
	instr Score

if (eu(3, 16, 4) == 1) then
	bi("Ilookintotheocean",
	5,
	scall("2B", gidorian, circle(1, fillarray(1, -1))),
	scall("2B", gidorian, circle(2, fillarray(6, 6, 7, 6))),
	$f)
endif

	endin



	start("Route")

	instr Route

getmeout("Ilookintotheocean", .85)
getmeout("Puck", .85)


	endin

