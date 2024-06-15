	instr score

gkpulse	= 105

;kdur	go 1, 25, 5
kdur	= 9
;		try 16
$if	eu(3, 16, 4, "heart") $then
	e("wendy",
	gkbeats*kdur,
	$f,
	step("5Ab", giwhole, pump(48, fillarray(1, 2, 7, 1, 3, 7))),
	step("4Eb", giwhole, pump(12, fillarray(1, 2, 7, 1, 3, 7))),
	step("3Ab", gipentamin, pump(48, fillarray(1, 2, 7, 1, 3, 7))))
endif

	endin
	start("score")
	instr route
kfla	= int(lfse(5, 15, gkbeatf/24))/100
printk2 kfla
flingue("wendy", a(kfla), .65)
routemeout("wendy", "shy")
	endin
	start("route")
