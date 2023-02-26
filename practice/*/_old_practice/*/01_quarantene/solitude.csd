	instr Score

gkpulse = go(115, 155, 105) + lfo(5, gkbeatf/32)

if (eu(8, 8, 1, "heart") == 1) then
	e("witches",
	gkbeats*8,
	$ff,
	scall("2C", gijapanese, pump(1, fillarray(5, 6, 4, 7, 5, 6, 3, 4))),
	scall("4C", gijapanese, pump(1, fillarray(5, 6, 4, 7, 5, 6, 3, 4)+2)))
endif

chnset(int(lfse(1, 5, gkbeatf/64)), "witches.mod")
chnset(lfse(3, 15, gkbeatf/32), "witches.ndx")
chnset(lfa(3.5, gkbeatf/32), "witches.detune")

if (eu(13, 16, 16, "heart") == 1) then
	e("snug",
	gkbeats/(2+lfo(2, gkbeatf*64, 3)),
	$fff,
	scall("3C", gijapanese, pump(1, fillarray(5, 6, 4, 7, 5, 6, 3, 4))),
	scall("3Eb", gimajor, pump(2, fillarray(5, 6, 4, 7, 5, 6, 3, 4))))
endif

givemednb(pump(16, fillarray(12, 16, 9, 32)), $f, "heart")

	endin
	start("Score")

	instr Route

kf	= gkbeatf/lfse(16, 24, gkbeatf/32)

chnset(.75, "k35.q")
chnset(scall("3C", gijapanese, pump(1, fillarray(5, 6, 4, 7, 5, 6, 3, 4)))+1$k+lfa(3$k, kf, 4), "k35.freq")
routemeout("witches", "k35", comeforme(155))
;routemeout("drum", "k35")

chnset(.25, "moog.q")
chnset(go(50, 165, 20$k), "moog.freq")
routemeout("snug", "moog")
;getmeout("snug", lfa(1, kf, 4))

	endin
	start("Route")
