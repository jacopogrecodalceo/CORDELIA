	instr score

gkpulse	= 95 + lfo(15, gkbeatf/2, 3)

if (lfo(1, gkbeatf/32, 3) == 1)then
	if (eu(1, 15, 4, "heart") == 1) then
		e("snug",
		gkbeats*8,
		lfse($fff, $mf, gkbeatf*4),
		scall("3Eb", gijapanese, lfia(3, gkbeatf*16)),
		scall("2Bb", gijapanese, lfia(7, gkbeatf*32)+1))
	endif
else
	if (eu(2, 15, 4, "heart") == 1) then
		e("snug",
		gkbeats*lfse(2, 8, gkbeatf*2),
		lfse($fff, $mf, gkbeatf*4),
		scall("2Eb", gijapanese, lfia(3, gkbeatf*16)),
		scall("3Bb", gijapanese, lfia(7, gkbeatf*32)+1))
	endif
endif

chnset(int(lfse(1, 5, gkbeatf/64)), "snug.mod")
chnset(lfse(1, 5, gkbeatf/32)*comeforme(45), "snug.ndx")

	endin
	start("score")

	instr route

chnset(lfse(.75, .25, gkbeatf/16), "moog.q")
chnset(lfse(20$k, 5$c, gkbeatf/32), "moog.freq")
routemeout("snug", "moog", comeforme(15))

	endin
	start("route")

