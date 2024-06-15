	start("Score")
	instr Score

kch = circle(1, fillarray(0, -2, 0, 5))

kdyn1	= abs(lfo($f, 1/circle(4, fillarray(.5, 1))))

gk_tempo = 95

if (eu(5, 7, 2) == 1) then
	bi("Juliet",
	beatsk(2),
	scall("4C", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("5G", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
elseif (eu(3, 9, 8) == 1) then
	e("Juliet",
	beatsk(2),	
	scall("5G", gidorian, circle(8, fillarray(1, 3, 2, 3)) - 1),
	kdyn1 * .5)
endif

if (eu(5, 7, 2) == 1) then
	bi("rePuck",
	beatsk(6),
	scall("3C", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
endif

	endin


	start("Route")
	instr Route
;routemeout("Juliet", "delirium", golin(0, 55, .55))

getmeout("rePuck", golin(1, 55, 0))
getmeout("Juliet")

	endin
