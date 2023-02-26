	instr score

gkpulse = 120

if gkroy1 == 1 then
	eva("between",
	gkbeats*4,
	accent(5, $f),
	giclassic$atk(5),
	step("4F", giminor, 2+$once(1, 3, 5)),
	step("4F", giminor, $once(1, 3, 5, 7)))

	gkroy1 = 0
endif


if gkroy2 == 1 then
	eva("betweenmore",
	gkbeats*4,
	accent(5, $f),
	giclassic$atk(5),
	step("3F", giminor, $once(1, 3, 5, 9)),
	step("4F", giminor, $once(1, 3, 5, 7))*$once(.25, .5, 1))

	gkroy2 = 0
endif

	endin
	start("score")

	
	instr route

flingj3("burd", lfh(9), .5)
flingj("bleu", 500, .75)
getmeout("qb")
getmeout("between")
getmeout("aaron")

	endin
	start("route")

