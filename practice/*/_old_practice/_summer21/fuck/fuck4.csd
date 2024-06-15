	instr score

gkpulse	= 90

if (hex("89f", 8) == 1) then
	evad(oncegen(gidist), "grind",
	gkbeats*once(fillarray(0, 0, 1, 24)),
	accent(3),
	once(fillarray(gieclassic, giclassic, gibite)),
	step("3B", gikumoi, 12+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("3B", gikumoi, 2+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("3B", gikumoi, pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))))
endif

if (hex("89f", 8) == 1) then
	evad(oncegen(gidist), "grind",
	gkbeats*once(fillarray(0, 0, 0, 24)),
	accent(3),
	once(fillarray(gibite, giclassic)),
	step("3B", gikumoi, 12+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("3B", gikumoi, 2+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("3B", gikumoi, pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))))
endif

if (hex("89f", 8) == 1) then
	evad(oncegen(gidist), "fim",
	gkbeats*once(fillarray(0, 0, 0, 24)),
	accent(3),
	once(fillarray(gibite, giclassic)),
	step("3B", gikumoi, 12+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("3B", gikumoi, 2+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("3B", gikumoi, pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))))
endif
	endin
	start("score")

	
	instr route

flingj4("grind", gkbeatms+pump(16, fillarray(gibeatms/2, 0, 5)), .995)
flingj3("grind", gkbeatms+pump(24, fillarray(gibeatms/8, 0, 15)), .995)
flingj2("grind", gkbeatms+pump(32, fillarray(gibeatms/4, 0, 5)), .995)

getmeout("fim")


	endin
	start("route")

