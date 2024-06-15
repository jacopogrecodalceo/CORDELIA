	start("Score")
	instr Score

if (eu(9, 16, 16) == 1) then
	e("rePuck",
	beatsk(.25),
	scall("4C", giiwato, circle(8, fillarray(1, 3, 2, 3))),
	$mf)
endif

if (eurexp(9, 16, 16) == 1) then
	e("Puck",
	beatsk(.25),
	scall("4D", giiwato, circle(8, fillarray(1, 3, 2, 3))),
	$mf)
endif

	endin



	start("Route")
	instr Route
;routemeout("Juliet", "delirium", golin(0, 55, .55))

getmeout("Puck", .5)

getmeout("rePuck", .5)
getmeout("Juliet", .5)

	endin

