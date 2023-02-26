	instr Score

gkpulse	= 75 + lfo(15, .05, 3)

if (eu(4, 4, pump(4, fillarray(16, 12)), "heart") == 1) then
	e("repuck",
	gkbeats * pump(32, fillarray(.5, .25, 3.5, 0, 0, 0)),
	pump(32, fillarray($mp, $mp, $f, 0, 0, 0)),
	step("2Ab", giquarter, pump(32, fillarray(1, 7, 12, 0, 0, 0)), lfo(3, gkbeatf*32)))
endif

if (eu(16, 16, pump(4, fillarray(16, 12)), "heart") == 1) then
	e("repuck",
	gkbeats * pump(32, fillarray(.5, .25, 3.5, 0, 0, 0)),
	pump(32, fillarray($mp, $mp, $f, 0, 0, 0)),
	step("3Ab", giquarter, pump(32, fillarray(1, 7, 12, 0, 0, 0)), lfo(3, gkbeatf*32)))
endif
	endin
	start("Score")

	instr Route
getmeout("repuck")
	endin
	start("Route")
