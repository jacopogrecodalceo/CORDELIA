	start("Score")
	instr Score

gk_tempo = 125 + lfo(125/2, 1/beatsk(8), 3)

printk2(gk_tempo)

if (eu(8, 8, 8) == 1) then
	bi("rePuck",
	beatsk(.5),
	scall("4C", giegyptian, circle(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7))),
	$mf)
endif

if (eu(8, 9, 8) == 1) then
	e("Juliet",
	beatsk(.5),
	scall("2C", giegyptian, circle(24, fillarray(1, 2, 5))),
	circle(24, fillarray($f, $mf, $f)))
endif

if (eu(1, 8, 1) == 1) then
	bi("Puck",
	beatsk(24),
	scall("4C", giegyptian, circle(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7))),
	$fff)
endif
	endin



	start("Route")
	instr Route
;routemeout("Juliet", "delirium", golin(0, 55, .55))

getmeout("Puck", .5)

getmeout("rePuck", .5)
getmeout("Juliet", .5)

	endin

