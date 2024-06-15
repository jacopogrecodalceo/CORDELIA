	instr score

gkpulse	= 90-samphold:k(timeh(2), metro:k(gkbeatf*2))

gkfim_var randomi 0, 1, .05

if (hex("89f0", 4) == 1) then
	evad(oncegen(gidist), "dmitri",
	gkbeats*once(fillarray(0, 0, 0, 24))*2,
	accent(3, $p),
	once(fillarray(gibite, giclassic)),
	step("3B", gikumoi, 12+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("2B", gikumoi, 2+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("3B", gikumoi, pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))))
endif

if (hex("89f", 4) == 1) then
	eva("fim", "witches",
	gkbeats*once(fillarray(8, 12, 0, 24)),
	accent(3, $p),
	once(fillarray(gibite, giclassic)),
	step("2B", gikumoi, 2+pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))),
	step("3B", gikumoi, pump(16, fillarray(1, random:k(0, 12), 2, 7, random:k(0, 12)))))
endif

	endin
	start("score")

	instr route

flingj4("dmitri", gkbeatms+pump(14, fillarray(gibeats/2, 0, 5)), .25)

kfb	= .75+lfa(.25, gkbeatf)
kndx	phasor gkbeatf/8

ringj3("dmitri", gkbeatf*pump(24, fillarray(.5, 1, 12)), kfb, morpheus(kndx, giclassic, gilowasquare, gilikearev))
flingj2("dmitri", gkbeatms+pump(32, fillarray(gibeats/4, 0, 5)), .25)

getmeout("puck")

foj("fim", step("1B", gikumoi, 1)*pump(2, fillarray(2, 3/2, 9/8, 1)))
foj("fim", step("2B", gikumoi, 3)*pump(3, fillarray(2, 3/2, 9/8, 1)))

foj("witches", step("4F#", gikumoi, 1)*pump(2, fillarray(2, 3/2, 9/8, 1)))
foj("witches", step("4F#", gikumoi, 3)*pump(3, fillarray(2, 3/2, 9/8, 1)))

	endin
	start("route")

