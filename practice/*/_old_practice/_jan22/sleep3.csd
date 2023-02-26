	instr score

gkpulse	= 90-samphold:k(timeh(2), metro:k(gkbeatf*8))

gkfim_var randomi 0, 1, .05

if (hex("89f0", 4) == 1) then
	evad(oncegen(gidist), "dmitri",
	gkbeats*once(fillarray(0, 0, 0, 24))*2,
	accent(3, $p),
	once(fillarray(gibite, giclassic)),
	step("1B", gikumoi, 12+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("0B", gikumoi, 2+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("2B", gikumoi, pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))))
endif
	endin
	start("score")

	instr route

flingj4("dmitri", gkbeatms+pump(14, fillarray(gibeatms/2, 0, 5)), .95)
flingj3("dmitri", pump(21, fillarray(gibeatms/8, 0, 15)), .5)
flingj2("dmitri", gkbeatms+pump(32, fillarray(gibeatms/4, 0, 5)), .85)

	endin
	start("route")

