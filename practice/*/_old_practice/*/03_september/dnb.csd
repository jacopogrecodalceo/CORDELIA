	instr Score
gkpulse = 175
givemednb(16, $f, "heart")

if (eu(5, pump(1, fillarray(12, 16)), 16, "heart") == 1) then
	e("puck",
	gkbeats/4,
	$mf,
	step("4G", gilocrian, pump(3, fillarray(3, 3, 2, 2, 7))),
	step("3G", gilocrian, pump(6, fillarray(3, 3, 2, 2, 7))),
	step("5E", gilocrian, pump(3, fillarray(3, 3, 2, 2, 7))))
endif

if (eu(5, 12, 4, "heart") == 1) then
	e("juliet",
	gkbeats*4,
	$mp,
	step("3G", gilocrian, pump(6, fillarray(3, 3, 2, 2, 7))),
	step("4G", gilocrian, pump(3, fillarray(3, 3, 2, 2, -5))),
	step("5C", gilocrian, pump(3, fillarray(3, 3, 2, 2, 0))))
endif

	endin
	start("Score")

	instr Route
chnset(gkbeats, "delirium.time")
chnset(.75 + lfa(.225, gkbeatf/12), "delirium.fb")
;routemeout("puck", "delirium")

routemeout("juliet", "bribes", 2)
routemeout("puck", "twinkle", 2)

chnset(.35 + lfo(.25, gkbeatf/32), "moog.q")
chnset(5500 + lfo(3500, gkbeatf/16), "moog.freq")
;routemeout("drum", "moog")

;getmeout("drum")
getmeout("juliet")
	endin
	start("Route")

