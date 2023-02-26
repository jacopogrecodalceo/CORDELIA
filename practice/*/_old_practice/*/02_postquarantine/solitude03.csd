	instr Score

if (eu(8, 8, 1, "heart") == 1) then
	e("witches",
	gkbeats*4,
	$ff,
	scall("2C", gijapanese, pump(1, fillarray(5, 6, 4, 7, 5, 6, 3, 4))),
	scall("4C#", gikumoi, pump(1, fillarray(6, 4, 7, 5, 6, 3, 4)+2)))
endif

chnset(int(lfse(1, 5, gkbeatf/64)), "witches.mod")
chnset(lfse(3, 15, gkbeatf/32), "witches.ndx")
chnset(lfa(15.5, gkbeatf/32), "witches.detune")

	endin
	start("Score")

	instr Route

getmeout("witches")

	endin
	start("Route")
