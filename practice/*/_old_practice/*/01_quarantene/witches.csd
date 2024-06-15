	instr score

gkpulse	= 120 + lfo(15, gkbeatf/2, 3)

if (eu(7, 12, 16, "heart") == 1) then
	e("witches",
	gkbeats/4+lfa(gkbeats/2, gkbeatf*4),
	pump(16, fillarray($ff, $mp)),
	scall("3G", gilocrian, lfia(12, gkbeatf*16)),
	scall("3G", gilocrian, lfia(12, gkbeatf*32)+1))
endif

chnset(int(lfse(1, 5, gkbeatf/16))*comeforme(25), "witches.mod")
chnset(int(lfse(1, 15, gkbeatf/16))*comeforme(25), "witches.ndx")

if (eu(4, 6, pump(4, fillarray(8, 16)), "heart") == 1) then
	e("puck",
	gkbeats*pump(4, fillarray(.5, 2)),
	pump(16, fillarray($mp, $ff)),
	scall("3G", gilocrian, pump(4, fillarray(1, 3, 2))),
	scall("3G", gilocrian, pump(3, fillarray(3, 2, 1))),
	scall("4G", gilocrian, pump(6, fillarray(2, 1, 3))))
endif

if (eu(7, 9, pump(4, fillarray(12, 4)), "heart") == 1) then
	e("repuck",
	gkbeats*pump(4, fillarray(1, 2)),
	$mf,
	scall("4G", gilocrian, pump(4, fillarray(1, 3, 2))))
endif
	endin
	start("score")

	instr route

routemeout("witches", "bribes")
routemeout("witches", "twinkle")

getmeout("witches")
getmeout("puck")
getmeout("repuck")

	endin
	start("route")
