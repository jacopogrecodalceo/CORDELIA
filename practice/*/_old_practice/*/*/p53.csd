	start("Score")

set_tempo(175)

	instr Score

kdyn1	= abs(lfo($ff, 1/circle(4, fillarray(beats(4), beats(2)))))

if (eu(7, 12, 8) == 1) then
	bi("Puck",
	beats(1) * kdyn1,
	scall("4C", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("4C", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7))),
	kdyn1)
endif

kdyn2	= abs(lfo($mf, 1/circle(1, fillarray(beats(8), beats(4)))))

if (eu(6, 12, 8) == 1) then
	bi("rePuck",
	beats(.5),
	scall("3G", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, circle(1, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7))),
	kdyn2)
endif


if (eu(3, 12, 16) == 1) then
	bi("Puck",
	beats(15) * kdyn2,
	scall("4Bb", giionian, circle(4, fillarray(1, 3, 2, 3, 1, 3, 2, 5))),
	scall("4Bb", giionian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7))),
	$mf)
endif

kdyn3	= abs(lfo($mf, 1/circle(2, fillarray(beats(2), beats(8)))))

if (eu(9, 16, 8) == 1) then
	e("Puck",
	.05 + kdyn1,
	scall("4C", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7))),
	kdyn3)
endif


if (givemearray(8, fillarray(1, 0, 0, 0, 0, 1, 0, 0)) == 1) then
	e("BD",
	1,
	1,
	1)
endif

if (givemearray(8, fillarray(0, 0, 1, 0, 0, 0, 1, 0)) == 1) then
	eran(beats(4),
	"SD",
	1,
	1,
	1)
endif

;routemeout("rePuck", "K35")

getmeout("rePuck")
getmeout("Puck")


	endin
