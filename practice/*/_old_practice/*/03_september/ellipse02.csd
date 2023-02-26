	instr Score

gkpulse	= 105 + lfo(95, gkbeatf/64)

if (eu(15, 16, pump(16, fillarray(16, 8)), "heart") == 1) then
	e("snug",
	gkbeats/lfse(2, 8, gkbeatf/32),
	$f,
	step("2Ab", gijapanese, pump(2, fillarray(3, 7, 12, 0, 5, 0))),
	step("3Ab", gijapanese, pump(6, fillarray(1, 3, 11, 6, 9, 0))),
	step("4Ab", gijapanese, pump(3, fillarray(5, 4, 12, 5, 5, 11))))
endif

if (eu(15, pump(16, fillarray(16, 8)), 2, "heart") == 1) then
	e("juliet",
	gkbeats*lfse(4, 1, gkbeatf/64),
	$p,
	step("1Ab", gijapanese, pump(2, fillarray(3, 7, 12, 0, 5, 0))),
	step("2Ab", gijapanese, pump(6, fillarray(1, 3, 11, 6, 9, 0))),
	step("5Ab", gijapanese, pump(3, fillarray(5, 4, 12, 5, 5, 11))))
endif

if (eu(3, 16, 1, "heart") == 1) then
	e("witches",
	gkbeats*12,
	$fff,
	step("1Ab", gijapanese, pump(2, fillarray(3, 7, 12, 0, 5, 0))),
	step("1Ab", gijapanese, pump(6, fillarray(1, 3, 11, 6, 9, 0))),
	step("1Ab", gijapanese, pump(3, fillarray(5, 4, 12, 5, 5, 11))))
endif


	endin
	start("Score")

	instr Route
chnset(lfse(1$c, 20$k, gkbeatf/lfse(1, 32, gkbeatf/128)), "moog.freq")
routemeout("snug", "moog")



getmeout("juliet")

getmeout("witches")
	endin
	start("Route")
