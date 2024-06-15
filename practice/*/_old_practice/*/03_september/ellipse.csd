	instr Score

gkpulse	= 75

if (eu(5, 16, 8, "heart") == 1) then
	e("witches",
	gkbeats*4,
	$f,
	step("3Ab", giquarter, pump(32, fillarray(1, 7, 12, 0, 0, 0)), lfo(3, gkbeatf*32)))
endif

	endin
	start("Score")

	instr Route
chnset(lfse(1$c, 15$k, gkbeatf/lfse(1, 32, gkbeatf/16)), "moog.freq")
routemeout("witches", "moog")
	endin
	start("Route")
