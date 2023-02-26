gkpulse = 75

	start("Score")
	instr Score

k1	= $abslfo($ff'1/beatsk(3))

if (eu(9, 13, 15) == 1) then
	bi("rePuck",
	.5,
	subsc("3B", 23, circle(2, fillarray(1, 1, 13))),
	subsc("3B", 15, circle(2, fillarray(2, 1, 13))),
	k1)
endif
if (eu(2, 13, 3) == 1) then
	bi("Puck",
	5,
	subsc("3B", 5, circle(2, fillarray(1, 1, 3))),
	subsc("2B", 9, circle(1, fillarray(1, 1, 7))),
	$f)
endif
	endin



	start("Route")

	instr Route

getmeout("Ilookintotheocean", .85)
getmeout("rePuck", .85)
getmeout("Puck", .85)


	endin

