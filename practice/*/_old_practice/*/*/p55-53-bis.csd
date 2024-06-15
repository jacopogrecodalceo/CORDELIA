	start("Score")

set_tempo(125)

	instr Score

kch = circle(1, fillarray(0, -2, 0, 3))
kchoth = circle(1, fillarray(0, 0, 1))

kdyn1	= abs(lfo($ff, 1/circle(4, fillarray(beats(4), beats(2)))))

if (eu(7, 12, 8) == 1) then
	bi("Puck",
	beats(1) * kdyn1,
	scall("4C", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("4C", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
endif

kdyn2	= abs(lfo($f, 1/circle(1, fillarray(beats(8), beats(4)))))

krel	= lfo(.95, beats(1), 3) * abs(lfo(.95, beats(32)))

if (eu(6, 12, 8) == 1) then
	bi("rePuck",
	beats(1) * kdyn1 + krel,
	scall("3G", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, circle(1, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch),
	kdyn2)
elseif (eu(3, 12, 16) == 1) then
	bi("Puck",
	beats(15) * kdyn2,
	scall("4Bb", giionian, circle(4, fillarray(1, 3, 2, 3, 1, 3, 2, 5))),
	scall("4Bb", giionian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch + kchoth),
	$mf)
endif

chnset(.15, "delirium.fb")
;routemeout("rePuck", "delirium", .05)

;routemeout("rePuck", "K35")

getmeout("rePuck", .5)
getmeout("Puck", .5)

	endin
