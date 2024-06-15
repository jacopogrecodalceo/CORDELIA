	instr Score

hmelody("repuck",
	1,
	2,
	$f,
	"3Ab",
	#sentimental)

hmelody("fairest",
	2,
	4,
	$mf,
	"4Ab",
	#sentimental)

chnset(int(lfse(1, 5, #beatf/64)), "witches.mod")
chnset(lfse(5, 15, #beatf/32), "witches.ndx")
chnset(lfa(3.5, #beatf/32), "witches.detune")

if (eu(8, 8, 1, "heart") == 1) then
	e("witches",
	#beats*8,
	$ff,
	step("1Ab", #ionian, pump(1, fillarray(5, 6, 4, 7))),
	step("2Ab", #ionian, pump(1, fillarray(5, 6, 4, 7)+2)))
endif

givemednb(7, $ff, "heart")

	endin
	start("Score")

	instr Route

chnset(#beats, "delirium.time")
chnset(.95, "delirium.fb")
routemeout("repuck", "delirium")
routemeout("drum", "delirium")

getmeout("repuck")
getmeout("fairest")
getmeout("witches", hlowa(1, 4))

chnset(.75, "moog.q")
routemeout("drum", "moog", hlowa(1, 4, 0, 3))

	endin
	start("Route")
