	instr score

gkpulse	= 90

if (hex("89f", 24) == 1) then
	evad(oncegen(-gidist), "grind",
	gkbeats*once(fillarray(1, 1, 1, 12)),
	accent(3),
	once(fillarray(gieclassic, giclassic)),
	step("2G", gikumoi, 12+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("1G", gikumoi, 2+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("2G", gikumoi, pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))))
endif

if (hex("89f", 16) == 1) then
	evad(oncegen(gidist), "grind",
	gkbeats*once(fillarray(1, 1, 1, 12)),
	accent(3),
	once(fillarray(gieclassic, giclassic)),
	step("2G", gikumoi, 12+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("1G", gikumoi, 2+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("2G", gikumoi, pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))))
endif
	endin
	start("score")

	
	instr route

flingj4("grind", gkbeatms+pump(16, fillarray(gibeatms/2, 0, 5)), .995)
flingj3("grind", gkbeatms+pump(24, fillarray(gibeatms/2, 0, 5)), .995)
flingj2("grind", gkbeatms+pump(32, fillarray(gibeatms/4, 0, 5)), .995)

	endin
	start("route")

