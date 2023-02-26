	instr Score

if (eu(1, 16, 16, "heart") == 1) then
	e("elle",
	gkbeats*8,
	$fff, 1)
endif

if (eu(3, 8, 16, "heart") == 1) then
	e("snug",
	gkbeats,
	$p,
	step("5B", gkdorian, pump(24, fillarray(0, 7*2, 5/2, -1, 2))))
endif

if (eu(3, 8, 4, "heart") == 1) then
	e("witches",
	gkbeats*4,
	$ppp,
	step("2B", gkdorian, pump(1, fillarray(0, 7*2, 5/2, -1, 2))),
	step("3F#", gkdorian, pump(1, fillarray(0, 7*2, 5/2, -1, 2))))
endif
	endin
	start("Score")

	instr Route

chnset(.005 + lfa(.15, gkbeatf), "sonre.bw")
chnset(step("6B", gkdorian, pump(24, fillarray(0, 7*2, 5/2, -1, 2))), "sonre.freq")
routemeout("elle", "sonre", pump(pump(12, fillarray(12, 48, 24)), fillarray(0, 1, 0, 1, 1)))

getmeout("snug", pump(48, fillarray(1, 0, 1, 0, 0, 1)) * hlowa(1, 1, 0, 1))

getmeout("witches", hlowa(1, 4, 0, 1))

	endin
	start("Route")
