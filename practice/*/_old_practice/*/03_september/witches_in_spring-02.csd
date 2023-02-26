	instr score

gkpulse	= 95 + lfo(55, gkbeatf/512, 3)

if (eu(3, 15, 4, "heart") == 1) then
	e("witches",
	gkbeats*8,
	lfse($fff, $mf, gkbeatf*4),
	step("2G", gijapanese, lfia(3, gkbeatf*16)),
	step("3Bb", gijapanese, lfia(7, gkbeatf*32)+1))
endif

chnset(int(lfse(1, 5, gkbeatf/64)), "witches.mod")
chnset(lfse(3, 15, gkbeatf/32), "witches.ndx")

if (eu(8, 15, 16, "heart") == 1) then
	e("repuck",
	gkbeats,
	$mp,
	step("4EB", gijapanese, lfia(3, gkbeatf*16)),
	step("3G", gijapanese, lfia(7, gkbeatf*32)+1))
endif

if (eu(9, 30, 8, "heart") == 1) then
	e("repuck",
	gkbeats*2,
	$mf,
	step("3Eb", gijapanese, lfo(15, gkbeatf*16)))
endif

	endin
	start("score")

	instr route

getmeout("witches")
getmeout("repuck", lfa(1, gkbeatf/128))

	endin
	start("route")
