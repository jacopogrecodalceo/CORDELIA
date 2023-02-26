	instr score

gkpulse	= 105

kch	pump 4, fillarray(0, 2, -2, 3)

$if eu(16, 16, 16, "heart") $then
	e("aaron",
	gkbeats/2,
	$fff,
	step("4Ab", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), kch))
endif

$if eu(12, 16, 16, "heart") $then
	e("puck",
	gkbeats/3,
	$ff,
	step("3Ab", giminor3, pump(48, fillarray(1, 2, 7, 1, 3, 7)), kch + 12*int(random:k(-2, 2))))
endif
	endin
	start("score")

	instr route
chnset(.15, "moog.q")
chnset(500 + randomh:k(50, 7500, gkbeatf/3), "moog.freq")

routemeout("puck", "moog")

getmeout("aaron")
	endin
	start("route")
