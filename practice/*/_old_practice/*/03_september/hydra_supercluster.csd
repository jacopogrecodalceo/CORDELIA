	instr Score

gkpulse	= 135

if (eu(7, 16, 32, "heart") == 1) then
	e("wendy",
	gkbeats,
	$fff*3,
	step("1Ab", gikumoi, pump(32, fillarray(1, 3, 5, 6))),
	step("2Ab", gikumoi, pump(32, fillarray(1, 3, 5, 6) + 1)))
endif

if (eu(3, 16, pump(32, fillarray(32, 24, 12)), "heart") == 1) then
	e("puck",
	gkbeats/8,
	$fff,
	step("3Ab", gikumoi, pump(32, fillarray(1, 3, 5, 6))),
	step("4Ab", gikumoi, pump(32, fillarray(1, 3, 5, 6)+4)),
	step("5Ab", gikumoi, pump(32, fillarray(1, 3, 5, 6) + 5)))
endif

if (eu(2, 12, 4, "heart") == 1) then
	e("ilookintotheocean",
	gkbeats*8,
	$fff,
	step("3A", gikumoi, pump(32, fillarray(1, 3, 5, 6)-1)),
	step("4D", gikumoi, pump(32, fillarray(1, 3, 5, 6))))
endif

	endin
	start("Score")

	instr Route
chnset(.95, "delirium.fb")
chnset(gkbeats/lfse(1, 4, .5), "delirium.time")
;routemeout("snug", "moog")
chnset(1900, "moog.freq")
routemeout("ilookintotheocean", "moog")
;hardduckmeout("wendy", "puck", .015, .015)
	endin
	start("Route")
