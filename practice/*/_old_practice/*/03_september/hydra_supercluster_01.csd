	instr score

gkpulse	= 115

chnset(int(lfse(1, 5, gkbeatf/64)), "witches.mod")
chnset(lfse(3, 15, gkbeatf/32), "witches.ndx")

if (eu(2, 14, 16, "heart") == 1) then
	e("repuck",
	gkbeats/4,
	$ff,
	step("4EB", gijapanese, lfia(3, gkbeatf*16)),
	step("3G", gijapanese, lfia(7, gkbeatf*32)+1))
endif

if (eu(49, 30, 8, "heart") == 1) then
	e("repuck",
	gkbeats/4,
	$ff,
	step("4Eb", gijapanese, lfo(15, gkbeatf*16)))
endif

if (eu(3, 30, 8, "heart") == 1) then
	e("witches",
	gkbeats/4,
	$mf,
	step("3Eb", gijapanese, lfo(15, gkbeatf*16)))
endif

if (eu(3, 23, 2, "heart") == 1) then
	e("witches",
	gkbeats*16,
	$fff,
	step("3C", giquarter, lfo(15, gkbeatf*16)),
	step("2E", giminor3, lfo(5, gkbeatf*64)),
	step("2E", giquarter, lfo(15, gkbeatf*32)),
	step("1D", giminor3, lfo(15, gkbeatf*16)))
endif

	endin
	start("score")

	instr route

chnset(.75, "moog.q")
;routemeout("witches", "moog", hlowa(1, gkbeatf*64, 0, 3))
;routemeout("repuck", "moog", hlowa(1, gkbeatf*32, .25, 3))
getmeout("witches", fadeaway(25))

	endin
	start("route")
