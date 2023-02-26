	instr score

gkpulse	= 95 + lfo(15, gkbeatf/2, 3)

if (eu(3, 15, 4, "heart") == 1) then
	e("witches",
	gkbeats*4,
	lfse($fff, $mf, gkbeatf*4),
	scall("3Eb", gijapanese, lfia(3, gkbeatf*16)),
	scall("2Bb", gijapanese, lfia(7, gkbeatf*32)+1))
endif

chnset(int(lfse(1, 5, gkbeatf/64)), "witches.mod")
chnset(lfse(3, 15, gkbeatf/32), "witches.ndx")

if (eu(8, 15, 16, "heart") == 1) then
	e("repuck",
	gkbeats,
	$mp,
	scall("4Eb", gijapanese, lfia(3, gkbeatf*16)),
	scall("3Bb", gijapanese, lfia(7, gkbeatf*32)+1))
endif

if (eu(9, 30, 8, "heart") == 1) then
	e("repuck",
	gkbeats*2,
	$mf,
	scall("3Eb", gijapanese, lfo(15, gkbeatf*16)))
endif

	endin
	start("score")

	instr route

getmeout("witches")
getmeout("repuck", lfa(1, gkbeatf/16))

	endin
	start("route")
