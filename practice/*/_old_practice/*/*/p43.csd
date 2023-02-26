	start("Score")

	instr Score

if (eu(9, 16, 3) == 1) then
	e("Puck",
	$long,
	in_scale(0, circle(5, fillarray(1, 2, 6)) + circle(3, fillarray(5, 7))),
	$fff)
endif

if (eu(9, 32, 6) == 1) then
	e("Juliet",
	.05,
	in_scale(2, circle(1, fillarray(1, 2))),
	$fff)
endif

routemeout("Juliet", "K35")
getmeout("Puck")		
	endin
