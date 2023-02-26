	instr score

gkpulse	= 128.5

kdyn	= $fff*lfh:k(8)
kdur	= 1+(12*lfh:k(12))

$if hex("1281", 32) $then
	eva("shinobi",
	gkbeats,
	accenth(4),
	giclassic$atk(5),
	once(fillarray(1, 3, 4, 8, 4, 3, 6, 2)))
endif

$if hex("1281", 32) $then
	eva("wutang",
	gkbeats*kdur,
	accenth(4, kdyn),
	gieclassic$atk(5),
	ntof("0F#")*once(fillarray(1, 3, 4, 8, 4, 3, 6, 2)))
endif

	endin
	start("score")

	instr route

getmeout("shinobi")
getmeout("wutang", lfh:a(1.25))
ringj7("wutang", 2, .5*lfh(4), gilowasine, .5*lfh:k(1))

	endin
	start("route")
