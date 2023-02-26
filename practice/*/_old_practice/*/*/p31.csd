instr Score

	if (eu(5, 8, 4) == 1) then
		e("Puck",
		$short,
		in_scale(-1, (circle(3, fillarray(1, 3, 5)))),
		$f,
		$qmed)
	endif

	if (eu(5, 9, 4) == 1) then
		eran(
		(circle(2, fillarray(beats(1), .05))),
		"Puck",
		$short,
		in_scale(-1, (circle(3, fillarray(2, 4, 1))) + (circle(1, fillarray(-1, 2)))),
		$f,
		$qmed)
	endif

	if (eu(5, 12, 1) == 1) then
		e(
		"StJacques",
		$long,
		in_scale(0, circle(3, fillarray(2, 4, 1))),
		$f,
		$long)
	endif

	if (eu(11, 13, 4) == 1) then
		e(
		"Puck",
		$short,
		in_scale(0, circle(4, fillarray(1, 0, 1, 2))),
		$mf,
		$short)
	endif


	if (eu(8, 13, 4) == 1) then
		e("BD",
		1,
		1,
		$fff)
	endif


endin

start("Score")
