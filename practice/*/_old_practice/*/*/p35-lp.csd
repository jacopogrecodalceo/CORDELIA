instr Score

	root("3G")
	gamme("aeloian")

	if	(eu(5, 11, 4) == 1) then
		e("Puck",
		$short,
		in_scale(0, circle(3, fillarray(1, 2, 3))),
		$mf,
		$qmed)

	elseif	(eu(32, 52, 8) == 1) then
		eran(circle(3, fillarray(beats(.5), 0)),
		"Puck",
		$short,
		in_scale(0, circle(5, fillarray(1, 2, 6)) + circle(3, fillarray(-5, -7))),
		$mf,
		$short)

	elseif	(eu(4, 5, 4) == 1) then
		e("Puck",
		$short,
		in_scale(1, circle(5, fillarray(0, 3, 7)) + circle(4, fillarray(1, -4))),
		$mf,
		$short)

	elseif	(eu(5, 15, 2) == 1) then
		e("Puck",
		$long,
		in_scale(-1, circle(5, fillarray(0, 2, 7)) + circle(4, fillarray(1, -4))),
		$mf,
		$long)
	endif

	if	(eu(3, 8, 4) == 1) then
		eran(2,
		"BD",
		beats(1),
		1,
		1)
		chnset(5, "BD.decay")
	endif

	chnset(1500 + lfo:k(1000, 1/measures(1)), "Puck.moogf")
	chnset(.5 + lfo:k(.45, 1/measures(1)), "Puck.moogr")

endin

start("Score")
