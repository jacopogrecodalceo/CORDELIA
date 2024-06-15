	instr score

gkpulse	= 150

kndx	lfa 1, gkbeatf/16

katk	pump 8, fillarray(2, 4, 2, .5, 2, 4, 2, 4, .5)

$if	eu(8, 16, 32, "heart") $then
	p(1, "ipercluster",
	gkbeats/katk,
	accent(8, $mp),
	morpheus(kndx, giclassic, gikazanr),
	edo("5C#", 5+pump(4, fillarray(0, 2, 0, 5)), once(fillarray(0, 2, 3, 4))))
endif

$if	eu(8, 16, 32, "heart") $then
	p(-1, "ipercluster",
	gkbeats/katk,
	accent(8, $mp),
	morpheus(kndx, gikazan, giclassicr),
	edo("5F#", 10+pump(4, fillarray(0, 2, 0, 5)), once(fillarray(0, 2, 3, 4))))
endif

	endin
	start("score")

	
	instr route

flingj3("ipercluster", gkbeats/pump(4, fillarray(2, 32, 8, 16)), .95)
flingj3("ipercluster", gkbeats/pump(16, fillarray(24, 16, 4, 64)), .95)
flingj3("ipercluster", gkbeats*pump(8, fillarray(.5, 1, 2, .25, 1, .5)), .995)

	endin
	start("route")

