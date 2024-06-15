	instr score

gkpulse	= 128.5

kdyn	= $fff*lfh:k(8)
kdur	= 1+(8*lfh:k(12))

$if hex("1281", 32) $then
	eva("shinobi",
	gkbeats,
	accent(4),
	giclassic$atk(5),
	once(fillarray(1, 3, 4, 8, 4, 3, 6, 2)))
endif

$if hex("1281", 32) $then
	eva("wutang",
	gkbeats*kdur,
	accent(4, kdyn),
	gieclassic$atk(5),
	ntof("0F#")*once(fillarray(1, 3, 4, 8, 4, 3, 6, 2)))

printk2 kdur
printk2 kdyn
endif

	endin
	start("score")

	instr route

getmeout("shinobi")
getmeout("wutang")

	endin
	start("route")
