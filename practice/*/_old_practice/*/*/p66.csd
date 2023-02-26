	start("Score")
	instr Score
k1	= $pp + $abslfo($f'1/beatsk(4))


if (eu(9, 16, 16) == 1) then
	tri("rePuck",
	beatsk(.15),
	scall("4C", giminor, circle(1, fillarray(1, 4, 3, 4))),
	scall("4C", giminor, circle(1, fillarray(1, 4, 3, 4))+1),
	scall("4C", giminor, circle(16, fillarray(6, -1, 1, 4))+9),
	k1)
endif

if (eu(9, 16, circle(8, fillarray(16, 16, 17, 16))) == 1) then
	e("Juliet",
	beatsk(circle(8, fillarray(.25, .5, .15, .35))),
	scall("4C", gidorian, circle(2, fillarray(5, 5, 6, 7))),
	k1)
endif

	endin



	start("Route")

	instr Route

chnset(.95, "delirium.fb")
;routemeout("rePuck", "delirium", .55)

getmeout("Puck", .5)

getmeout("rePuck", .85)
getmeout("Juliet", .85)

	endin

