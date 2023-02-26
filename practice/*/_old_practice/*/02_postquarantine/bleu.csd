	instr Score

#pulse	= 135

hmelody("repuck",
	2,
	1,
	$ff,
	"4D",
	#bleu)

hmelody("repuck",
	1,
	2,
	$ff,
	"3G",
	#bleu)

if (eu(8, 8, 1, "heart") == 1) then
	e("witches",
	#beats*8,
	$ff,
	step("1D", #ionian, pump(1, fillarray(5, 6, 4, 7, 5, 6, 3, 4))),
	step("2D", #ionian, pump(1, fillarray(5, 6, 4, 7, 5, 6, 3, 4)+2)))
endif

if (eu(9, 16, 16, "heart") == 1) then
	e("puck",
	#beats,
	$f,
	step("3D", #ionian, pump(1, fillarray(5, 6, 4, 7, 5, 6, 3, 4))),
	step("4G", #ionian, pump(1, fillarray(5, 6, 4, 7, 5, 6, 3, 4)+2)))
endif

chnset(int(lfse(1, 5, #beatf/64)), "witches.mod")
chnset(lfse(5, 15, #beatf/32), "witches.ndx")
chnset(lfa(3.5, #beatf/32), "witches.detune")

givemekick(4, pump(4, fillarray(16, 8)), 16, "heart", 3, .15, hlowa($f, 8))
givemekick(3, 8, 16, "heart", 11, .05, hlowa($ff, 16, .5))
givemekick(3, 9, 16, "heart", 15, .5, $f)

	endin
	start("Score")

	instr Route

chnset(#beats/2, "delirium.time")
chnset(.95, "delirium.fb")
routemeout("repuck", "delirium")
routemeout("witches", "delirium")

followdrum("witches")
followdrum("repuck")
getmeout("drum")
getmeout("puck")

	endin
	start("Route")
