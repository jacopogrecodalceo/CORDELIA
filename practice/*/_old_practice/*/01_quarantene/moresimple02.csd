	instr Score

if (eu(6, 6, pump(4, fillarray(16, 18)), "heart") == 1) then
	e("puck",
	gkbeats*2,
	lfse($p, $ppp, gkbeatf*32),
	step("3C", gkkumoi, pump(2, fillarray(1, 1, -1, 1))),
	step("3C", gkkumoi, pump(2, fillarray(3, 4, 2, 2))),
	step("3C", gkkumoi, pump(2, fillarray(5, 5, 6, 7))))
endif

if (eu(18, 32, 16, "heart") == 1) then
	e("snug",
	gkbeats/lfse(2, 3, gkbeatf*8),
	heartmurmur(4, $ff),
	step("4C", gkkumoi, pump(2, fillarray(1, 1, -1, 1))),
	step("4C", gkkumoi, pump(2, fillarray(3, 4, 2, 2))),
	step("4C", gkkumoi, pump(2, fillarray(5, 5, 6, 7))))
endif

if (eu(1, 6, pump(4, fillarray(16, 18)), "heart") == 1) then
	e("fairest",
	gkbeats*4,
	lfse($fff, $f, gkbeatf*32),
	step("2C", gkkumoi, pump(2, fillarray(1, 1, -1, 1))))
endif
	endin
	start("Score")



	instr Route

routemeout("puck", "twinkles")
routemeout("puck", "bribes")
getmeout("puck")

chnset(lfse(.25, .75, gkbeatf/8, 4), "moog.freq")
chnset(lfse(5$c, 5$k, gkbeatf/8, 4), "moog.freq")
routemeout("snug", "moog")
routemeout("fairest", "moog")

	endin
	start("Route")
