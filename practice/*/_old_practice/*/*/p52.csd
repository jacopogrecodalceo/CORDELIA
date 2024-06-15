	start("Score")

set_tempo(175)

	instr Score

if (eu(7, 12, 8) == 1) then
	bi("Puck",
	beats(.5),
	scall("4C", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("4C", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7))),
	$f)
endif

kdyn	= abs(lfo($ff, 1/beats(8)))

if (eu(7, 12, 8) == 1) then
	bi("rePuck",
	beats(.5),
	scall("3G", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, circle(1, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7))),
	kdyn)
endif

if (eu(3, 12, 16) == 1) then
	bi("Puck",
	beats(15) * kdyn,
	scall("4Bb", giionian, circle(8, fillarray(1, 3, 2, 3))),
	scall("4Bb", giionian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7))),
	$ff)
endif


getmeout("rePuck")

getmeout("Puck")

	endin
