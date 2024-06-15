	instr Score

if (eu(2, 16, 16, "heart") == 1) then
	e("elle",
	gkbeats*8,
	$fff, 1)
endif

	endin
	start("Score")

	instr Route

chnset(.005 + lfa(.15, gkbeatf), "sonre.bw")
chnset(step("6B", gkdorian, pump(24, fillarray(0, 7*2, 5/2, -1, 2))), "sonre.freq")
routemeout("elle", "sonre", pump(48, fillarray(0, 1, 0, 1)))

	endin
	start("Route")
