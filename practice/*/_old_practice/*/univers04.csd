	instr score

kndx	lfa 1, gkbeatf/32

if (eu(6, 16, 16, "heart") == 1) then
	eva("fim",
	gkbeats/4,
	accent(3, $ff, $ppp),
	morpheus(kndx, gilikearev$atk(5), gikazan),
	step("1D", giminor3, pump(4, fillarray(1, 3, -1, 2))-1)*once(fillarray(2, 4, 2)),
	step("2D", giminor3, pump(2, fillarray(1, 3, -1, 2))-1)*once(fillarray(1, 2, 4, 2)),
	step("0D", giminor3, pump(2, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))
endif

if (eu(9, 16, 16, "heart", 4) == 1) then
	eva("fim",
	gkbeats/random:k(2, 4),
	accent(3, $ff, $ppp),
	morpheus(kndx, gilikearev$atk(5), gimirror),
	step("2D", giminor3, pump(4, fillarray(1, 3, -1, 2))-1)*once(fillarray(2, 4, 2)),
	step("0D", giminor3, pump(2, fillarray(1, 3, -1, 2))-1)*once(fillarray(1, 2, 4, 2)),
	step("1D", giminor3, pump(2, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))
endif

if (eu(12, 16, 16, "heart", 1) == 1) then
	eva("fim",
	gkbeats/4,
	accent(3, $ff, $ppp),
	morpheus(kndx, gilikearev$atk(5), gieclassic),
	step("0D", giminor3, pump(4, fillarray(1, 3, -1, 2))-1)*once(fillarray(2, 4, 2)),
	step("0D", giminor3, pump(2, fillarray(1, 3, -1, 2))-1)*once(fillarray(1, 2, 4, 2)),
	step("1D", giminor3, pump(2, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))
endif
	endin
	start("score")

	instr route
moogj("burd", pump(8, fillarray(.5, .05, 1, 5))*1000, .95, 3)
flingj3("burd", pump(24, fillarray(.5, .05, 1, 5))*50, .95)
powerranger("burd", pump(32, fillarray(.5, .05, 1, 5)))

flingj3("fim", pump(24, fillarray(.5, .05, 1, 5))*10, .75)
flingj3("fim", pump(16, fillarray(.5, .05, 1, 5))*20, .5)

	endin
	start("route")
