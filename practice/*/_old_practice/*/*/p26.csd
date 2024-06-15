instr SCORE
	schedkwhen(euph(3, 11), 0, 12,
	"Puck",
	0,
	$short,
	in_scale(0, 1),
	$ff,
	$long)

	schedkwhen(euph(3, 4), 0, 12,
	"Puck",
	0,
	$short,
	in_scale(1, 1),
	$ff,
	$long)
endin

schedule("SCORE", 0, 5)
