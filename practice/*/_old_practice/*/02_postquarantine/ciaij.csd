	instr Score

gkpulse = 115 + lfo(5, gkbeatf/32)

hmelody("repuck",
	2,
	$mf,
	"3Ab",
	gkciaij4)

hmelody("puck",
	4,
	$mf,
	"4Eb",
	gkciaij4)

hmelody("witches",
	1,
	$f,
	"3Ab",
	gkciaij4)

if (eu(9, 16, 16, "heart") == 1) then
	e("snug",
	gkbeats/4,
	$f,
	step("3Ab", gkionian, pump(16, fillarray(1, 3, 5, 8)) + pump(2, fillarray(0, -2, 1, -5))))
endif

givemednb(16, $f, "heart")

	endin
	start("Score")

	instr Route

routemeout("puck", "bribes")
routemeout("snug", "twinkle")

getmeout("puck")
getmeout("witches")
getmeout("snug")
getmeout("drum")

	endin
	start("Route")
