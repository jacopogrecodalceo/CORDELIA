	instr score

gkpulse	= 95 + lfo(15, gkbeatf/2, 3)

if (lfo(1, gkbeatf/32, 3) == 1)then
	if (eu(3, 15, 4, "heart") == 1) then
		e("witches",
		gkbeats*8,
		lfse($fff, $mf, gkbeatf*4),
		scall("3Eb", gijapanese, lfia(3, gkbeatf*16)),
		scall("2Bb", gijapanese, lfia(7, gkbeatf*32)+1))
	endif
else
	if (eu(3, 15, 4, "heart") == 1) then
		e("witches",
		gkbeats*lfse(2, 8, gkbeatf*2),
		lfse($fff, $mf, gkbeatf*4),
		scall("2Eb", gijapanese, lfia(3, gkbeatf*16)),
		scall("3Bb", gijapanese, lfia(7, gkbeatf*32)+1))
	endif
endif

chnset(int(lfse(1, 5, gkbeatf/64)), "witches.mod")
chnset(lfse(1, 5, gkbeatf/32)*comeforme(45), "witches.ndx")
chnset(lfa(5, gkbeatf/32), "witches.detune")

if (eu(11, 15, 16, "heart") == 1) then
	e("repuck",
	gkbeats*lfse(.25, 2, gkbeatf*4),
	$mp,
	scall("4Eb", gijapanese, pump(3, fillarray(1, 3, 3, 2))),
	scall("3Bb", gijapanese, pump(5, fillarray(3, 4, 5, 7))+1))
endif

if (eu(15, 15, 16, "heart") == 1) then
	e("repuck",
	gkbeats*lfse(.15, 1, gkbeatf*4),
	$p,
	scall("4Eb", gijapanese, pump(1, fillarray(1, 3, 3, 2)+3)))
endif

if (eu(15, 15, 12, "heart") == 1) then
	e("repuck",
	gkbeats*lfse(.15, 1, gkbeatf*4),
	$pp,
	scall("4Eb", gijapanese, pump(3, fillarray(1, 3, 3, 2)+3)))
endif

if (eu(11, 15, 1, "heart") == 1) then
	e("fairest",
	gkbeats*8,
	$fff,
	scall("2Eb", gijapanese, pump(3, fillarray(1, 3, 3, 2))))
endif

	endin
	start("score")

	instr route

chnset(lfse(.75, .25, gkbeatf/16), "moog.q")
chnset(lfse(20$k, 5$c, gkbeatf/32), "moog.freq")
routemeout("witches", "moog", comeforme(15))
getmeout("repuck", lfa(1, gkbeatf/128)*comeforme(65))
getmeout("fairest", comeforme(35))

	endin
	start("route")

