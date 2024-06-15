	instr score

gkpulse	= 40-timeh(2)

gkfim_var randomi 0, 1, .05

if (hex("89f", 4) == 1) then
	eva("burd",
	gkbeats*once(fillarray(0, 0, 0, 24)),
	accent(3, $mf, $ppp),
	once(fillarray(gispina, gibite, gispina)),
	step("4B", gikumoi, pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("5B", gikumoi, 2+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("3B", gikumoi, pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))))
endif

gkgain = 1

	endin
	start("score")

	
	instr route

flingj4("grind", gkbeatms+pump(16, fillarray(gibeatms/2, 0, 5)), .995)
flingj3("grind", gkbeatms+pump(24, fillarray(gibeatms/8, 0, 15)), .995)
flingj2("grind", gkbeatms+pump(32, fillarray(gibeatms/4, 0, 5)), .995)

flingj4("burd", gkbeatms+pump(16, fillarray(gibeatms*4, 0, 5)), .95)
flingj2("burd", gkbeatms+pump(16, fillarray(gibeatms*2, 0, 5)), .95)

	endin
	start("route")

