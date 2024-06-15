instr Score

	root("3G")
	gamme("aeloian")

	kdyn = abs(lfo:k(.5, beats(4)))

	if	(eu(10, 11, 8) == 1) then
		e("Puck",
		$short,
		in_scale(0, circle(3, fillarray(1, 2, 3))),
		kdyn,
		$qmed)
	endif

endin

start("Score")
