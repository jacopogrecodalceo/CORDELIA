	instr Score

gkpulse	= 95 + pump(8, fillarray(0, 55, -35, 105))

if (eu(15, 16, pump(32, fillarray(16, 4)), "heart") == 1) then
	e("puck",
	gkbeats/lfse(2, 16, gkbeatf/32),
	$fff,
	step("1Ab", gijapanese, pump(2, fillarray(3, 7, 12, 0, 5, 0))),
	step("3Ab", gijapanese, pump(6, fillarray(1, 3, 11, 0, 9, 0))),
	step("1Ab", gijapanese, pump(3, fillarray(5, 4, 12, 0, 5, 11))))
endif

if (eu(15, 16, pump(32, fillarray(16, 4)), "lungs") == 1) then
	e("snug",
	gkbeats/lfse(.5, 8, gkbeatf/64),
	lfse($ppp, $fff, gkbeatf/32),
	step("1Ab", gijapanese, pump(2, fillarray(3, 7, 12, 0, 5, 0))),
	step("3Ab", gijapanese, pump(6, fillarray(1, 3, 11, 6, 9, 0))),
	step("1Ab", gijapanese, pump(3, fillarray(5, 4, 12, 5, 5, 11))))
endif
	endin
	start("Score")

	instr Route
chnset(lfse(.15, .75, gkbeatf/32), "moog.q")
chnset(lfse(35, 5$c, gkbeatf/lfse(1, 32, gkbeatf/128)), "moog.freq")
routemeout("puck", "moog")

getmeout("deliriumson", 4)
getmeout("deliriumdaughter", 4)

routemeout("snug", "bribes", 4)
routemeout("puck", "twinkles", 4)
routemeout("puck", "bribes", 4)
	endin
	start("Route")
