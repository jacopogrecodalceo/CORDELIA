	start("Score")

	instr Score

if (eu(9, 16, 3) == 1) then
	e("Puck",
	$long,
	in_scale(-1, circle(5, fillarray(1, 2, 6)) + circle(3, fillarray(5, 7))),
	$fff)
endif

if (eu(9, 16, 3) == 1) then
	e("Puck",
	$long,
	in_scale(-1, circle(3, fillarray(1, 2, 6)) + circle(3, fillarray(5, 7))),
	$fff)
endif

if (eu(1, 32, 1) == 1) then
	e("Juliet",
	measures(16),
	in_scale(-1, circle(3, fillarray(1, 2))),
	$fff)
endif

getmeout("Juliet")
getmeout("Puck")		
	endin

gamme("dorian")
