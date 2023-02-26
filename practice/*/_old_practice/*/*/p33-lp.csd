instr Score

	root("3B")

	if	(eu(2, 3, 2) == 1) then
		gamme(circleS(4, fillarray("octa12", "locrian")))
	endif

	if	(eu(5, 8, 4) == 1) then
		e("Puck",
		$short,
		in_scale(0, (circle(3, fillarray(1, 7, 4)))),
		$mf,
		$qmed)
	elseif	(eu(3, 8, 8) == 1) then
		e("Puck",
		$short,
		in_scale(0, (circle(5, fillarray(1, 2, 6)))),
		$mf,
		$short)
	elseif	(eu(4, 14, 8) == 1) then
		e("Puck",
		$short,
		in_scale(1, (circle(5, fillarray(0, 3, 7)) + circle(4, fillarray(1, -4)))),
		$mf,
		$short)
	elseif	(eu(5, 16, 2) == 1) then
		e("Puck",
		$long,
		in_scale(-1, (circle(5, fillarray(0, 3, 7)) + circle(4, fillarray(1, -4)))),
		$mf,
		$long)
	endif

	chnset((5500 + lfo:k(4000, .05)), "Puck.moog")

endin

start("Score")
