	instr score

gkpulse	= 105

kdur	go 1, 25, 5
;kdur	= 1
;		try 16
$if	eu(9, 16, 9, "heart") $then
	e("puck",
	gkbeats*kdur,
	$f,
	step("1Ab", giwhole, pump(48, fillarray(1, 2, 7, 1, 3, 7))),
	step("3Eb", giwhole, pump(12, fillarray(1, 2, 7, 1, 3, 7))),
	step("3Ab", gipentamin, pump(48, fillarray(1, 2, 7, 1, 3, 7))))
endif

;		try 4
$if	eu(3, 16, 2, "heart", 1) $then
	e("aaron",
	gkbeats*8,
	$mf,
	step("3C", giwhole, pump(48, fillarray(1, 2, 7, 1, 3, 7))),
	step("5F", giwhole, pump(12, fillarray(1, 2, 7, 1, 3, 7))),
	step("4G", gipentamin, pump(48, fillarray(1, 2, 7, 1, 3, 7))))
endif

	endin
	start("score")
	instr route
routemeout("puck", "shy")
routemeout("aaron", "shy")
routemeout("fim", "shy")

flingue("aaron", a(lfse(.005, .095, gkbeatf/24)), .5)
chnset(lfse(50, 15$k, gkbeatf/8), "moog.freq")
routemeout("aaron", "moog")
flingue("puck", a(lfse(.005, .015, gkbeatf/8)), .5)
	endin
	start("route")
