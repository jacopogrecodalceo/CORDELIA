	instr score

gkpulse = 120-timeh(1)

if (eu(12, 16, 8, "heart") == 1) then
	eva("burd",
	gkbeats*4,
	accent(3, $f),
	gilikearev$atk(5),
	step("3D", giminor3, pump(4, fillarray(1, 3, -1, 2))-1)*once(fillarray(2, 4, 2)),
	step("2D", giminor3, pump(2, fillarray(1, 3, -1, 2))-1)*once(fillarray(1, 2, 4, 2)),
	step("2D", giminor3, pump(2, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))
endif

kndx	lfa 1, gkbeatf/32

if (eu(6, 16, 16, "heart") == 1) then
	eva("burd",
	(gkbeats/2)+kndx,
	accent(3, $mf),
	morpheus(kndx, gilikearev$atk(5), gimirror),
	step("4D", giminor3, pump(4, fillarray(1, 3, -1, 2))-1)*once(fillarray(2, 4, 2)),
	step("3D", giminor3, pump(2, fillarray(1, 3, -1, 2))-1)*once(fillarray(1, 2, 4, 2)),
	step("3D", giminor3, pump(2, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))
endif

	endin
	start("score")

	instr route

kch	pump 4, fillarray(1, .5, .75, 2)

k1	pump 8, fillarray(32, 48, 16, 64)

moogj("burd", pump(8, fillarray(.5, .05, 1, 5))*500+(500*lfh(1)), .95, 1.5)
flingj3("burd", pump(24, fillarray(kch/2, .05, kch, kch*3.5))*50+(25*lfh(3)), .95*lfh(4))
powerranger("burd", pump(k1, fillarray(.5, .05, 1, 5)))
	endin
	start("route")
