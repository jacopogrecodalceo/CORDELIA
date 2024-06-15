instr Score

	root("3Gb")
	gamme("locrian")

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

	if	(eu(5, 9, 3) == 1) then
		e("rePuck",
		$short,
		in_scale(1, circle(2, fillarray(1, 2, 7))),
		$mf,
		$short)
	elseif	(eu(5, 9, 3) == 1) then
		e("rePuck",
		$short,
		in_scale(2, circle(2, fillarray(2, 1, 6))),
		$mf,
		$short)
	endif

	;nofx("rePuck", "delirium")
	;nofx("Puck", "K35")
	;nofx("Puck", "Moog")
	
	chnset(5000 + lfo:k(3000, 1/measures(5)), "Moog.freq")
	chnset( abs(lfo:k(1, .05)), "delirium.time")
	chnset(.75, "delirium.fb")

	nofx("rePuck", "delirium", .95)

	;getmeout("rePuck")
	getmeout("Puck")

endin

start("Score")
