instr Score

	root("3G")
	gamme("aeloian")

	k1 = abs(lfo:k($ff, beats(4)))
	k2 = abs(lfo:k($mf, beats(8)))
	k3 = abs(lfo:k($fff, beats(3)))

	
	it = 6

	if	(eu(10, 11, it) == 1) then
		e("Puck",
		$short,
		in_scale(0, circle(4, fillarray(1, 2, 3))),
		k1,
		$qmed)
	endif

	if	(eu(10, 11, it) == 1) then
		e("Puck",
		$short,
		in_scale(-1, circle(3, fillarray(6, 5, 2))),
		k2,
		$qmed)
	endif

	if	(eu(3, 8, it) == 1) then
		e("BD",
		$long,
		in_scale(-3, circle(3, fillarray(6, 5, 2))),
		1,
		$long)
	endif

	if	(eu(11, 11, it) == 1) then
		e("CHH",
		$short,
		in_scale(0, circle(3, fillarray(6, 5, 2))),
		k3,
		$short)
	endif


endin

start("Score")
