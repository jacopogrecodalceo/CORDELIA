	instr score

gkpulse	= abs(70-randomh:k(-55, 55, gkbeatf/8)-timeh(2))

k1 pump 2, fillarray(3, 4, 8, 8)

kch pump k1, fillarray(0, -4, 1, 0)

if (hex("a0", 16) == 1) then
	eva("fim",
	gkbeats*accent(3, 4, $ff),
	accent(3, $pp),
	giclassic$atk(5),
	step("1B", giwhole, pump(48, fillarray(1, 2, 3, 7)), kch))
endif

kdur1	= 2+oscil:k(6, gkbeatf/8, gilowatri)
kdur2	= 1+oscil:k(12, gkbeatf/8, gilowatri)
kdur3	= 1+oscil:k(16, gkbeatf/16, gilowatri)

if (hex("a0a9", 24) == 1) then
	eva(oncegen(girot), "fim",
	gkbeats*accent(6, kdur1, $ff),
	accent(3, $ff),
	gilikearev$atk(5),
	step("2B", giwhole, pump(48, fillarray(1, 2, 3, 7)), kch))
endif

if (hex("9a0a", 24) == 1) then
	eva(oncegen(girot)+1, "fim",
	gkbeats*accent(6, kdur2, $ff),
	accent(3, $mf, $p),
	gilikearev$atk(5),
	step("2B", giwhole, pump(48, fillarray(1, 2, 3, 7)), kch))
endif

if (hex("a9a0", 24) == 1) then
	eva(oncegen(girot)+2, "fim",
	gkbeats*accent(6, kdur3, $ff),
	accent(3, $mf, $p),
	gilikearev$atk(5),
	step("2B", giwhole, pump(48, fillarray(1, 2, 3, 7)), kch))
endif


if (hex("9a0a", 32) == 1) then
	evad(oncegen(gidist), "fim",
	gkbeats*accent(6, kdur1, $ff),
	accent(12, $mp, $ppp),
	gilikearev$atk(5),
	step("4F#", giwhole, pump(48, fillarray(1, 2, 3, 7)), kch))
endif

	endin
	start("score")

	
	instr route

kch pump 4, fillarray(1, 3, 5, -5)

stringj("fim", step("3B", giwhole, kch+pump(48, fillarray(1, 2, 3, 7))), portk(pump(32, fillarray(.85, .5, .85, .95)), 5$ms))
stringj("fim", step("3F#", giwhole, kch+pump(24, fillarray(1, 2, 3, 7))), portk(pump(24, fillarray(.85, .5, .5, .95)), 5$ms))
stringj("fim", step("1F#", giwhole, kch+pump(32, fillarray(1, 2, 3, 7))), portk(pump(16, fillarray(.85, .5, .75, .95)), 5$ms))

flingj("fim", (gkbeatms/4)*pump(8, fillarray(2, 3, 3, 1)), portk(pump(12, fillarray(.85, .25, .85, .95)), gkbeatms/64))

	endin
	start("route")

