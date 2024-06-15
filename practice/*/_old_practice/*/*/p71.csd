	start("Score")
	instr Score

if (givemearray(32, fillarray(1, 0, 0, 1)) == 1) then
	e("rePuck",
	beatsk(1),
	scall("3B", gilocrian, circle(4, fillarray(1, 1, 2))),
	$mf)
endif

	endin

	start("Route")
	instr Route

gkpulse = 135

getmeout("rePuck")
getmeout("Puck")

	endin

