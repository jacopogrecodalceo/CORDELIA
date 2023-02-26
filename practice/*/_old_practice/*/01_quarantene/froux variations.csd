	instr Score

if (eu(1, 16, 16, "heart") == 1) then
	e("froux",
	gkbeats*8,
	$ff, 1)
endif

if (eu(3, 12, 8, "heart") == 1) then
	e("snug",
	gkbeats*(4-hlowa(3, 2)),
	$pp,
	step("5B", gkjapanese, pump(24, fillarray(0, 2*2, 5/2, -1, 3))))
endif

if (eu(5, 32, 12, "heart") == 1) then
	e("repuck",
	gkbeats*(4-hlowa(3, 2)),
	$pp,
	step("4B", gkjapanese, pump(8, fillarray(0, 2*4, 5/2, -1, 3/2))))
endif

if (eu(3, 8, 4, "heart") == 1) then
	e("witches",
	gkbeats*4,
	$mf,
	step("2B", gkjapanese, pump(1, fillarray(0, 2*2, 5/2, -1, 3))),
	step("3F#", gkjapanese, pump(1, fillarray(0, 2*2, 5/2, -1, 3))))
endif
	endin
	start("Score")

	instr Route

chnset(gkbeatf/(.5 + hlowa(4, 3)), "delirium.time")
routemeout("froux", "delirium", hlowa(1, 6, 0, 1))
routemeout("repuck", "delirium", hlowa(1, 3, 0, 1))

chnset(.005 + lfa(.15, gkbeatf), "sonre.bw")
chnset(step("5B", gkjapanese, pump(24, fillarray(0, 2*2, 5/2, -1, 3))), "sonre.freq")
;routemeout("froux", "sonre", pump(pump(12, fillarray(12, 48, 24)), fillarray(0, 1, 0, 1, 1)))
routemeout("froux", "sonre", pump(pump(12, fillarray(12, 48, 24)), fillarray(1, 0, 1)))

getmeout("snug", pump(48, fillarray(1, 0, 1, 0, 0, 1)) * hlowa(1, 1, 0, 1))

getmeout("witches", hlowa(1, 4, 0, 1))

	endin
	start("Route")
