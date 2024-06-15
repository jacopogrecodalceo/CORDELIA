	start("Score")
	instr Score

kplus	= int(randomh:k(-2, 2, 1/25))

printk2(kplus)

kch = circle(1, fillarray(0, -2, 0, 5) + kplus)

kdyn1	= abs(lfo($f, 1/circle(4, fillarray(.5, 1))))

gk_tempo = 95

if (eu(5, 7, 2) == 1) then
	bi("Juliet",
	beatsk(1.5),
	scall("4C", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("5G", giegyptian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
elseif (eu(3, 9, 8) == 1) then
	e("Juliet",
	beatsk(1.5),	
	scall("5G", gidorian, circle(8, fillarray(1, 3, 2, 3)) - 1 + kplus),
	kdyn1 * .5)
endif

if (eu(5, 7, 2) == 1) then
	bi("rePuck",
	beatsk(6),
	scall("3C", giegyptian, circle(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
endif

k1[]	= fillarray(1, 1, 0, 0, 0, 0, 0, 0)

if (givemearray(6, k1) == 1) then
	bi("rePuck",
	beatsk(2),
	scall("4C", giegyptian, circle(8, fillarray(1, 3, 2, 3)) - 3),
	scall("3G", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch + 3),
	kdyn1)
endif

	endin



	start("Route")
	instr Route
;routemeout("Juliet", "delirium", golin(0, 55, .55))

getmeout("rePuck", .5)
getmeout("Juliet", .5)

	endin
