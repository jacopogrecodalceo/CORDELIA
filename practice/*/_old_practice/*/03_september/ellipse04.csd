	instr Score

gkpulse	= 35 + lfse(0, 95, gkbeatf/64)

if (eu(15, 16, pump(16, fillarray(16, 8)), "heart") == 1) then
	e("snug",
	gkbeats*lfse(2, 8, gkbeatf/64),
	$f,
	step("2F", gikumoi, pump(2, fillarray(3, 7, 12, 0, 5, 0))),
	step("3F", gikumoi, pump(6, fillarray(1, 3, 11, 6, 9, 0))),
	step("4F", gikumoi, pump(3, fillarray(5, 4, 12, 5, 5, 11))))
endif

if (eu(15, pump(16, fillarray(16, 8)), 2, "heart") == 1) then
	e("juliet",
	gkbeats*lfse(4, 1, gkbeatf/64),
	$p,
	step("1F", gikumoi, pump(2, fillarray(3, 7, 12, 0, 5, 0))),
	step("2F", gikumoi, pump(6, fillarray(1, 3, 11, 6, 9, 0))),
	step("5F", gikumoi, pump(3, fillarray(5, 4, 12, 5, 5, 11))))
endif

if (eu(3, 16, 1, "heart") == 1) then
	e("witches",
	gkbeats*12,
	lfse($ff, $pp, 32),
	step("1F", gikumoi, pump(2, fillarray(3, 7, 12, 0, 5, 0))),
	step("1F", gikumoi, pump(6, fillarray(1, 3, 11, 6, 9, 0))),
	step("1F", gikumoi, pump(3, fillarray(5, 4, 12, 5, 5, 11))))
endif

if (eu(1, 16, 16, "heart") == 1) then
	e("axread",
	gkbeats*8,
	$fff, 1)
endif

	endin
	start("Score")

	instr Route
chnset(lfse(55, 1$k, gkbeatf/lfse(1, 32, gkbeatf/64)), "moog.freq")
routemeout("snug", "moog", lfa(1, gkbeatf/2))

getmeout("axread")

getmeout("juliet")

getmeout("witches", lfa(1, .05))
	endin
	start("Route")
